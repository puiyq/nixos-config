//! Entry point for the `pkexec` shim binary.
//!
//! Parses arguments, builds the `run0` command line, spawns it, and
//! forwards its exit code verbatim.  No exit-code translation is done
//! here: `run0` already returns 126/127 for authentication failures,
//! matching the semantics documented in `pkexec(1)`.

use std::process::{Command, exit};

use run0_pkexec_shim::*;

fn main() {
    let opts = parse_args();
    let argv = build_run0_argv(&opts);

    let mut cmd = Command::new(run0_bin());
    cmd.args(&argv);

    let status = match cmd.spawn() {
        Ok(mut child) => child.wait().unwrap_or_else(|e| {
            eprintln!("pkexec: failed to wait for child: {e}");
            exit(1);
        }),
        Err(e) => {
            // run0 itself could not be launched — this is a shim
            // configuration problem, not an authorization failure.
            eprintln!("pkexec: failed to execute run0: {e}");
            exit(1);
        }
    };

    // Forward run0's exit code directly.  POSIX signals that terminate the
    // child without an exit code are mapped to 1 as a safe fallback.
    exit(status.code().unwrap_or(1));
}
