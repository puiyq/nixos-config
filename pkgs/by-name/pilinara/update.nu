#!/usr/bin/env nix-shell
#! nix-shell -i nu -p nix-prefetch-git yq-go git nushell

const OWNER = "Starfallan"
const REPO = "PiliNara"

# Find the local (editable) package directory
def find-pkg-dir [] {
    let git_root = try {
        ^git -C (pwd) rev-parse --show-toplevel | str trim
    } catch {|_| "" }
    let found = [
        ($env.CURRENT_FILE | path dirname | path expand)
        (pwd)
        ($git_root | path join "pkgs/by-name/pilinara")
    ]
    | where {|d| ($d | path join "package.nix" | path exists) }
    if ($found | is-empty) {
        error make {msg: "Cannot find package directory. Run from the pilinara package dir or the repo root."}
    }
    $found | first
}

# GitHub API GET; --full returns the raw {status, headers, body} response
def gh-get [path: string, --full] {
    let token = $env | get -o GITHUB_TOKEN | default ""
    let url = $"https://api.github.com($path)"
    # Avoid passing --headers with an empty record; some Nu versions mishandle it
    if ($token | is-not-empty) {
        let h = {Authorization: $"Bearer ($token)"}
        if $full { http get --full --headers $h $url } else { http get --headers $h $url }
    } else {
        if $full { http get --full $url } else { http get $url }
    }
}

# Run nix-prefetch-git, capturing stderr to keep terminal output clean
def prefetch-git [url: string, rev: string] {
    let r = ^nix-prefetch-git --url $url --rev $rev | complete
    if $r.exit_code != 0 {
        error make {msg: $"nix-prefetch-git failed for ($url) @ ($rev)"}
    }
    $r.stdout | from json
}

# Extract total commit count from the GitHub pagination Link header
def get-commit-count [rev: string] {
    let resp = gh-get --full $"/repos/($OWNER)/($REPO)/commits?sha=($rev)&per_page=1"
    let link_values = (
        $resp.headers.response
        | where {|r| ($r.name | str lowercase) == "link" }
        | get value
    )
    let link = if ($link_values | is-empty) { "" } else {
        $link_values | first
    }
    let match = $link | parse --regex '[&?]page=(?P<n>\d+)>; rel="last"'
    if ($match | is-empty) {
        error make {msg: "Cannot determine git commit count from GitHub response"}
    }
    $match | get n | first | into int
}

# Build updated git-hashes record, reusing existing hashes for unchanged deps
def update-git-hashes [new_pubspec, old_pubspec, old_hashes] {
    $new_pubspec.packages
    | transpose name info
    | where {|it| $it.info.source == "git" }
    | get name
    | reduce --fold {} { |name, acc|
        let new_desc = $new_pubspec.packages | get $name | get description
        let old_desc = try { $old_pubspec.packages | get $name | get description } catch {|_| null }
        let hash = if $old_desc == $new_desc and ($old_hashes | get -o $name | is-not-empty) {
            print -e $"Reused existing git hash for dependency ($name)"
            $old_hashes | get $name
        } else {
            print -e $"Updating git hash for dependency ($name)..."
            (prefetch-git $new_desc.url $new_desc.resolved-ref).hash
        }
        $acc | upsert $name $hash
    }
}

# ── Main ──────────────────────────────────────────────────────────────────────
let pkg_dir = find-pkg-dir
let pkg_nix = $pkg_dir | path join "package.nix"
let src_info = $pkg_dir | path join "src-info.json"
let pubspec_lock = $pkg_dir | path join "pubspec.lock.json"
let git_hashes = $pkg_dir | path join "git-hashes.json"
let old_version = open $pkg_nix | parse --regex 'version\s*=\s*"(?P<v>[^"]+)"' | get v | first
let old_src = open $src_info
print -e $"Current version: ($old_version)  ($old_src.rev)  ($old_src.hash)"

# /releases/latest excludes pre-releases; use the list endpoint instead
let new_version = gh-get $"/repos/($OWNER)/($REPO)/releases?per_page=1" | first | get tag_name
if $new_version == $old_version {
    print -e "Already up-to-date"
    exit 0
}

let prefetch = prefetch-git $"https://github.com/($OWNER)/($REPO).git" $new_version
let new_rev = $prefetch.rev
let new_hash = $prefetch.hash
let src_path = $prefetch.path
let commit_date = $prefetch.date | into datetime | format date "%s" | into int
print -e $"New version: ($new_version)  ($new_rev)  ($new_hash)"

let git_count = get-commit-count $new_rev
let old_pubspec = open $pubspec_lock
let yq_r = ^yq -o=json eval . $"($src_path)/pubspec.lock" | complete
if $yq_r.exit_code != 0 { error make {msg: $"Failed to read pubspec.lock from ($src_path)"} }
let new_pubspec = $yq_r.stdout | from json

{
    rev: $new_rev
    revCount: $git_count
    commitDate: $commit_date
    hash: $new_hash
}
| to json --indent 2
| save --force $src_info
print -e $"Updated ($src_info)"

open --raw $pkg_nix | str replace $old_version $new_version | save --force $pkg_nix
print -e $"Updated ($pkg_nix)"

$new_pubspec | to json --indent 2 | save --force $pubspec_lock
print -e $"Updated ($pubspec_lock)"

update-git-hashes $new_pubspec $old_pubspec (open $git_hashes)
| to json --indent 2
| save --force $git_hashes

print -e $"Updated ($git_hashes)"
print -e "All done"
