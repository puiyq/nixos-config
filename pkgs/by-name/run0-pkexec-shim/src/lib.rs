//! # run0-pkexec-shim
//!
//! A compatibility shim that implements the `pkexec(1)` command-line interface
//! but delegates execution to `run0(1)` (systemd's unprivileged privilege
//! escalation tool) instead of polkit.
//!
//! ## Argument mapping
//!
//! | pkexec flag            | run0 equivalent                          |
//! |------------------------|------------------------------------------|
//! | `--user USER`          | `--user USER`                            |
//! | `--keep-cwd` (absent)  | `--chdir <target home>`                  |
//! | `--keep-cwd` (present) | *(omitted — run0 keeps the caller's cwd)*|
//! | *(always)*             | `--setenv PKEXEC_UID=<caller uid>`       |
//! | *(no PROGRAM)*         | `--via-shell`                            |
//!
//! ## Environment
//!
//! Set `RUN0_BIN` to override the path to the `run0` binary (default: `"run0"`).

use std::{
    env,
    ffi::{CStr, CString, OsStr, OsString},
    mem::MaybeUninit,
    os::unix::ffi::{OsStrExt, OsStringExt},
    process::exit,
    ptr,
};

/// The crate version, taken from `Cargo.toml` at compile time.
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

// ────────────────────────────────────────────────────────────────────────────
// Types
// ────────────────────────────────────────────────────────────────────────────

/// Parsed representation of the pkexec command line.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Opts {
    /// When `true` (`--keep-cwd`), do **not** switch to the target user's home
    /// directory; instead keep the caller's current working directory.
    pub keep_cwd: bool,

    /// Target user name, numeric UID, or `#UID` form.
    /// Defaults to `"root"` if absent.
    pub user: Option<OsString>,

    /// The program and its arguments to execute.
    /// If empty, `run0` is invoked with `--via-shell`.
    pub command: Vec<OsString>,
}

// ────────────────────────────────────────────────────────────────────────────
// Environment helpers
// ────────────────────────────────────────────────────────────────────────────

/// Returns the path (or name) of the `run0` binary to invoke.
///
/// Reads `$RUN0_BIN`; falls back to `"run0"` (i.e. PATH lookup).
pub fn run0_bin() -> OsString {
    env::var_os("RUN0_BIN").unwrap_or_else(|| OsString::from("run0"))
}

/// Returns the effective UID of the calling process via `getuid(2)`.
pub fn current_uid() -> libc::uid_t {
    // SAFETY: getuid is always safe to call.
    unsafe { libc::getuid() }
}

// ────────────────────────────────────────────────────────────────────────────
// Help / version
// ────────────────────────────────────────────────────────────────────────────

/// Prints the help message to stdout and returns.
///
/// The caller is expected to `exit(0)` immediately after (as `parse_args` does).
pub fn print_help() {
    println!(
        r#"Shim for the pkexec command that utilizes run0

Usage:
    pkexec [OPTIONS] [PROGRAM] [ARGUMENTS...]

Options:
    --user USER
        run command as specified user name or ID

    --keep-cwd
        keep the current working directory instead of switching to
        the target user's home directory

    --disable-internal-agent
        ignored (compatibility with pkexec)

    --help
        show this help message

    --version
        show version information
"#
    );
}

// ────────────────────────────────────────────────────────────────────────────
// Argument parsing
// ────────────────────────────────────────────────────────────────────────────

/// Parses `std::env::args_os()` into [`Opts`].
///
/// Exits the process for `--help` and `--version`.
pub fn parse_args() -> Opts {
    parse_args_from(env::args_os())
}

/// Parses an arbitrary iterator of `OsString` arguments into [`Opts`].
///
/// The first item is treated as `argv[0]` (the program name) and is skipped.
///
/// # Exits
///
/// - `0` for `--help` and `--version`
/// - `2` if `--user` is given without a following value
pub fn parse_args_from<I>(argv: I) -> Opts
where
    I: IntoIterator<Item = OsString>,
{
    let mut argv = argv.into_iter();
    let _ = argv.next(); // skip argv[0]

    let mut keep_cwd = false;
    let mut user = None;
    let mut command = Vec::new();

    while let Some(arg) = argv.next() {
        match arg.to_str() {
            Some("--version") => {
                println!("run0-pkexec-shim {VERSION}");
                exit(0);
            }

            Some("--help") => {
                print_help();
                exit(0);
            }

            // Accepted for compatibility with real pkexec; has no effect here
            // because we do not spawn a polkit authentication agent.
            Some("--disable-internal-agent") => {}

            Some("--keep-cwd") => keep_cwd = true,

            Some("--user") => {
                let v = argv.next().unwrap_or_else(|| {
                    eprintln!("pkexec: missing --user argument");
                    exit(2);
                });
                user = Some(v);
            }

            // Support both `--user alice` and `--user=alice`.
            Some(s) if s.starts_with("--user=") => {
                user = Some(OsString::from(&s["--user=".len()..]));
            }

            // First unrecognised argument — treat it and everything after it
            // as the PROGRAM + ARGUMENTS to execute.
            _ => {
                command.push(arg);
                command.extend(argv);
                break;
            }
        }
    }

    Opts {
        keep_cwd,
        user,
        command,
    }
}

// ────────────────────────────────────────────────────────────────────────────
// User / UID helpers
// ────────────────────────────────────────────────────────────────────────────

/// Parses a user specifier into a numeric UID, if possible.
///
/// Accepts plain decimals (`"0"`, `"1000"`) and the `#UID` prefix form
/// (`"#0"`, `"#1000"`).  Returns `None` for non-numeric strings such as
/// `"root"` or `"alice"`.
pub fn parse_uid_spec(user: &OsString) -> Option<u32> {
    let s = user.to_str()?;
    let s = s.strip_prefix('#').unwrap_or(s);
    s.parse().ok()
}

/// Returns `true` if `user` refers to the root account (UID 0 or the name
/// `"root"`).
pub fn user_is_root(user: &OsString) -> bool {
    match parse_uid_spec(user) {
        Some(uid) => uid == 0,
        None => user.as_os_str() == OsStr::new("root"),
    }
}

// ────────────────────────────────────────────────────────────────────────────
// passwd lookups
// ────────────────────────────────────────────────────────────────────────────

/// Extracts the home directory (`pw_dir`) from a `passwd` entry.
///
/// Returns `None` if the `pw_dir` pointer is null or empty.
fn home_from_passwd(pwd: &libc::passwd) -> Option<OsString> {
    if pwd.pw_dir.is_null() {
        return None;
    }
    // SAFETY: pw_dir is non-null and points to a C string owned by the
    // buffer we passed to getpwnam_r / getpwuid_r.  The buffer outlives
    // this call because it is borrowed by the caller via `pwd`.
    unsafe {
        Some(OsString::from_vec(
            CStr::from_ptr(pwd.pw_dir).to_bytes().to_vec(),
        ))
    }
}

/// Looks up the home directory for the given user **name** via `getpwnam_r(3)`.
///
/// Returns `None` if the user does not exist or the lookup fails.
pub fn lookup_home_by_name(name: &OsStr) -> Option<OsString> {
    // CString::new fails only if `name` contains an interior NUL byte, which
    // is not a valid Unix username.
    let c = CString::new(name.as_bytes()).ok()?;
    let mut buf_len = 1024usize;

    loop {
        let mut pwd = MaybeUninit::<libc::passwd>::zeroed();
        let mut result: *mut libc::passwd = ptr::null_mut();
        let mut buf = vec![0u8; buf_len];

        // SAFETY: all pointers are valid for the lifetime of this block.
        let ret = unsafe {
            libc::getpwnam_r(
                c.as_ptr(),
                pwd.as_mut_ptr(),
                buf.as_mut_ptr() as *mut libc::c_char,
                buf.len(),
                &mut result,
            )
        };

        match ret {
            // Success: result == null means "user not found".
            0 => {
                if result.is_null() {
                    return None;
                }
                // SAFETY: ret == 0 and result is non-null, so pwd is initialised.
                let pwd = unsafe { pwd.assume_init() };
                return home_from_passwd(&pwd);
            }
            // Buffer too small — double it and retry.
            libc::ERANGE => buf_len = buf_len.saturating_mul(2),
            // Any other errno means a hard failure.
            _ => return None,
        }
    }
}

/// Looks up the home directory for the given **UID** via `getpwuid_r(3)`.
///
/// Returns `None` if the UID does not exist or the lookup fails.
pub fn lookup_home_by_uid(uid: u32) -> Option<OsString> {
    let mut buf_len = 1024usize;

    loop {
        let mut pwd = MaybeUninit::<libc::passwd>::zeroed();
        let mut result: *mut libc::passwd = ptr::null_mut();
        let mut buf = vec![0u8; buf_len];

        // SAFETY: all pointers are valid for the lifetime of this block.
        let ret = unsafe {
            libc::getpwuid_r(
                uid as libc::uid_t,
                pwd.as_mut_ptr(),
                buf.as_mut_ptr() as *mut libc::c_char,
                buf.len(),
                &mut result,
            )
        };

        match ret {
            0 => {
                if result.is_null() {
                    return None;
                }
                // SAFETY: ret == 0 and result is non-null, so pwd is initialised.
                let pwd = unsafe { pwd.assume_init() };
                return home_from_passwd(&pwd);
            }
            libc::ERANGE => buf_len = buf_len.saturating_mul(2),
            _ => return None,
        }
    }
}

/// Resolves the home directory for `user`, which may be a name, a plain UID,
/// or a `#UID`-prefixed string.
///
/// Delegates to [`lookup_home_by_uid`] or [`lookup_home_by_name`] as
/// appropriate.
pub fn lookup_target_home(user: &OsString) -> Option<OsString> {
    if let Some(uid) = parse_uid_spec(user) {
        return lookup_home_by_uid(uid);
    }
    lookup_home_by_name(user.as_os_str())
}

// ────────────────────────────────────────────────────────────────────────────
// run0 argv construction
// ────────────────────────────────────────────────────────────────────────────

/// Builds the argument list to pass to `run0`.
///
/// # Behaviour
///
/// * Always passes `--user <target>` (defaults to `root`).
/// * Unless `--keep-cwd` was given, passes `--chdir <target_home>` when the
///   home directory can be resolved.  This matches the real pkexec behaviour
///   of running the program in the target user's home directory by default.
///   Omitting `--chdir` when `keep_cwd` is true causes `run0` to inherit the
///   caller's working directory naturally.
/// * Always passes `--setenv PKEXEC_UID=<caller_uid>` for compatibility with
///   programs that read this variable.
/// * Passes `--via-shell` when no PROGRAM was given; otherwise appends the
///   PROGRAM and its ARGUMENTS verbatim.
pub fn build_run0_argv(opts: &Opts) -> Vec<OsString> {
    let target_user = opts
        .user
        .as_deref()
        .unwrap_or(OsStr::new("root"))
        .to_os_string();

    let mut v: Vec<OsString> = Vec::new();

    v.push("--user".into());
    v.push(target_user.clone());

    // pkexec always changes to the target user's home unless --keep-cwd is set.
    // When keep_cwd is true we simply omit --chdir; run0 then keeps the
    // caller's cwd without any extra work on our part.
    if !opts.keep_cwd
        && let Some(home) = lookup_target_home(&target_user)
    {
        v.push("--chdir".into());
        v.push(home);
    }

    v.push("--setenv".into());
    v.push(format!("PKEXEC_UID={}", current_uid()).into());

    if opts.command.is_empty() {
        v.push("--via-shell".into());
    } else {
        v.extend(opts.command.iter().cloned());
    }

    v
}

// ────────────────────────────────────────────────────────────────────────────
// Tests
// ────────────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    // ── helpers ──────────────────────────────────────────────────────────────

    /// Turn a slice of `&str` into the iterator shape `parse_args_from` expects,
    /// including a fake argv[0].
    fn args(argv: &[&str]) -> impl Iterator<Item = OsString> {
        let mut v: Vec<OsString> = vec![OsString::from("pkexec")];
        v.extend(argv.iter().map(OsString::from));
        v.into_iter()
    }

    // ── parse_args_from ───────────────────────────────────────────────────────

    #[test]
    fn parse_empty_args() {
        let opts = parse_args_from(args(&[]));
        assert!(!opts.keep_cwd);
        assert!(opts.user.is_none());
        assert!(opts.command.is_empty());
    }

    #[test]
    fn parse_keep_cwd() {
        let opts = parse_args_from(args(&["--keep-cwd"]));
        assert!(opts.keep_cwd);
    }

    #[test]
    fn parse_user_space_separated() {
        let opts = parse_args_from(args(&["--user", "alice"]));
        assert_eq!(opts.user.as_deref(), Some(OsStr::new("alice")));
    }

    #[test]
    fn parse_user_equals_form() {
        let opts = parse_args_from(args(&["--user=bob"]));
        assert_eq!(opts.user.as_deref(), Some(OsStr::new("bob")));
    }

    #[test]
    fn parse_command_after_options() {
        let opts = parse_args_from(args(&["--user", "alice", "ls", "-la", "/tmp"]));
        assert_eq!(
            opts.command,
            vec![
                OsString::from("ls"),
                OsString::from("-la"),
                OsString::from("/tmp"),
            ]
        );
    }

    #[test]
    fn parse_command_stops_at_first_non_flag() {
        // "--keep-cwd" appearing after the program name is part of the command,
        // not a flag for pkexec.
        let opts = parse_args_from(args(&["ls", "--keep-cwd"]));
        assert!(!opts.keep_cwd);
        assert_eq!(
            opts.command,
            vec![OsString::from("ls"), OsString::from("--keep-cwd")]
        );
    }

    #[test]
    fn parse_disable_internal_agent_is_ignored() {
        let opts = parse_args_from(args(&["--disable-internal-agent", "id"]));
        assert_eq!(opts.command, vec![OsString::from("id")]);
    }

    #[test]
    fn parse_all_flags_combined() {
        let opts = parse_args_from(args(&["--keep-cwd", "--user=carol", "env"]));
        assert!(opts.keep_cwd);
        assert_eq!(opts.user.as_deref(), Some(OsStr::new("carol")));
        assert_eq!(opts.command, vec![OsString::from("env")]);
    }

    // ── parse_uid_spec ────────────────────────────────────────────────────────

    #[test]
    fn uid_spec_plain_zero() {
        assert_eq!(parse_uid_spec(&OsString::from("0")), Some(0));
    }

    #[test]
    fn uid_spec_plain_number() {
        assert_eq!(parse_uid_spec(&OsString::from("1000")), Some(1000));
    }

    #[test]
    fn uid_spec_hash_prefix() {
        assert_eq!(parse_uid_spec(&OsString::from("#1000")), Some(1000));
    }

    #[test]
    fn uid_spec_name_returns_none() {
        assert_eq!(parse_uid_spec(&OsString::from("root")), None);
        assert_eq!(parse_uid_spec(&OsString::from("alice")), None);
    }

    #[test]
    fn uid_spec_negative_returns_none() {
        // "-1" is not a valid u32
        assert_eq!(parse_uid_spec(&OsString::from("-1")), None);
    }

    // ── user_is_root ──────────────────────────────────────────────────────────

    #[test]
    fn root_by_name() {
        assert!(user_is_root(&OsString::from("root")));
    }

    #[test]
    fn root_by_uid_zero() {
        assert!(user_is_root(&OsString::from("0")));
    }

    #[test]
    fn root_by_hash_uid_zero() {
        assert!(user_is_root(&OsString::from("#0")));
    }

    #[test]
    fn non_root_name() {
        assert!(!user_is_root(&OsString::from("alice")));
    }

    #[test]
    fn non_root_uid() {
        assert!(!user_is_root(&OsString::from("1000")));
    }

    // ── build_run0_argv ───────────────────────────────────────────────────────

    /// Collect the run0 argv produced for given opts, without the
    /// `--chdir` entry (its value depends on the test host's /etc/passwd).
    fn argv_without_chdir(opts: &Opts) -> Vec<OsString> {
        let v = build_run0_argv(opts);
        let mut out = Vec::new();
        let mut skip_next = false;
        for arg in &v {
            if skip_next {
                skip_next = false;
                continue;
            }
            if arg == "--chdir" {
                skip_next = true;
                continue;
            }
            out.push(arg.clone());
        }
        out
    }

    #[test]
    fn argv_defaults_to_root_via_shell() {
        let opts = Opts {
            keep_cwd: false,
            user: None,
            command: vec![],
        };
        let v = argv_without_chdir(&opts);
        assert_eq!(v[0], "--user");
        assert_eq!(v[1], "root");
        assert!(v.contains(&OsString::from("--via-shell")));
    }

    #[test]
    fn argv_explicit_user() {
        let opts = Opts {
            keep_cwd: false,
            user: Some(OsString::from("alice")),
            command: vec![OsString::from("id")],
        };
        let v = argv_without_chdir(&opts);
        assert_eq!(v[0], "--user");
        assert_eq!(v[1], "alice");
        assert!(v.contains(&OsString::from("id")));
        assert!(!v.contains(&OsString::from("--via-shell")));
    }

    #[test]
    fn argv_keep_cwd_suppresses_chdir() {
        let opts = Opts {
            keep_cwd: true,
            user: Some(OsString::from("root")),
            command: vec![OsString::from("id")],
        };
        let v = build_run0_argv(&opts);
        assert!(
            !v.contains(&OsString::from("--chdir")),
            "expected no --chdir when keep_cwd is true, got: {v:?}"
        );
    }

    #[test]
    fn argv_always_sets_pkexec_uid() {
        let opts = Opts {
            keep_cwd: true,
            user: None,
            command: vec![],
        };
        let v = build_run0_argv(&opts);
        let setenv_pos = v.iter().position(|a| a == "--setenv");
        assert!(setenv_pos.is_some(), "--setenv must be present");
        let val = &v[setenv_pos.unwrap() + 1];
        assert!(
            val.to_string_lossy().starts_with("PKEXEC_UID="),
            "expected PKEXEC_UID=…, got {val:?}"
        );
    }

    #[test]
    fn argv_command_forwarded_verbatim() {
        let opts = Opts {
            keep_cwd: true,
            user: None,
            command: vec![
                OsString::from("bash"),
                OsString::from("-c"),
                OsString::from("echo hello"),
            ],
        };
        let v = build_run0_argv(&opts);
        let bash_pos = v.iter().position(|a| a == "bash").expect("bash not found");
        assert_eq!(v[bash_pos + 1], "-c");
        assert_eq!(v[bash_pos + 2], "echo hello");
    }

    // ── passwd lookups (live, best-effort) ────────────────────────────────────

    #[test]
    fn lookup_root_home_by_name() {
        // root always exists on Unix; home is typically /root but may differ.
        let home = lookup_home_by_name(OsStr::new("root"));
        assert!(home.is_some(), "lookup of 'root' by name should succeed");
        let home = home.unwrap();
        assert!(!home.is_empty(), "root home should not be empty");
    }

    #[test]
    fn lookup_root_home_by_uid() {
        let home = lookup_home_by_uid(0);
        assert!(home.is_some(), "lookup of uid 0 should succeed");
    }

    #[test]
    fn lookup_name_and_uid_agree_for_root() {
        let by_name = lookup_home_by_name(OsStr::new("root"));
        let by_uid = lookup_home_by_uid(0);
        assert_eq!(by_name, by_uid);
    }

    #[test]
    fn lookup_nonexistent_user_returns_none() {
        let home = lookup_home_by_name(OsStr::new("thisuserdoesnotexist_run0shimtest_xyzzy"));
        assert!(home.is_none());
    }

    #[test]
    fn lookup_very_high_uid_returns_none() {
        // UID u32::MAX is virtually guaranteed not to exist.
        assert!(lookup_home_by_uid(u32::MAX).is_none());
    }
}
