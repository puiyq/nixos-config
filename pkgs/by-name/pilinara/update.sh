#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix nix-prefetch-git jq curl yq-go

set -euo pipefail

PKG_EXPR='let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./. {}'

log()    { printf '%s\n' "$*" >&2; }
die()    { log "$*"; exit 1; }
finish() { log "$*"; exit 0; }

nix_attr() {
  nix-instantiate --eval --json --strict --attr "$1" -E "$PKG_EXPR" \
    | jq -r . || die "nix-instantiate failed when reading attr $1"
}

gh_curl() {
  # writes response headers to $GH_HDR, prints body to stdout
  local auth=()
  [[ -n "${GITHUB_TOKEN:-}" ]] && auth=(-H "Authorization: Bearer $GITHUB_TOKEN")
  curl -fsS -D "$GH_HDR" "${auth[@]}" "https://api.github.com$1" \
    || die "Failed to fetch $1"
}

prefetch_git() {
  nix-prefetch-git --url "$1" --rev "$2" 2>/dev/null \
    || die "nix-prefetch-git failed for $1 @ $2"
}

GH_HDR=$(mktemp)
trap 'rm -f "$GH_HDR"' EXIT

owner=$(nix_attr src.owner)
repo=$(nix_attr src.repo)
git_url="https://github.com/${owner}/${repo}.git"

old_version=$(nix_attr version)
old_rev=$(nix_attr src.rev)
old_hash=$(nix_attr src.outputHash)
log "Current version: $old_version $old_rev $old_hash"

# /releases/latest excludes drafts AND pre-releases. If upstream's most
# recent publish is tagged as a pre-release, that endpoint keeps returning
# the old stable tag forever, so the script always reports "up to date"
# even when a newer version exists. Use the releases list (newest first)
# instead.
releases=$(gh_curl "/repos/${owner}/${repo}/releases?per_page=1")
new_version=$(jq -r '.[0].tag_name // empty' <<<"$releases")
[[ -n "$new_version" ]] || die "No releases found for ${owner}/${repo}"

[[ "$new_version" == "$old_version" ]] && finish "Already up-to-date"

prefetch=$(prefetch_git "$git_url" "$new_version")
new_rev=$(jq -r .rev <<<"$prefetch")
new_hash=$(jq -r .hash <<<"$prefetch")
src_path=$(jq -r .path <<<"$prefetch")
date=$(date -d "$(jq -r .date <<<"$prefetch")" +%s)
log "New version: $new_version $new_rev $new_hash"

gh_curl "/repos/${owner}/${repo}/commits?sha=${new_rev}&per_page=1" >/dev/null
git_count=$(grep -i '^link:' "$GH_HDR" | grep -oP '[&?]page=\K\d+(?=>; rel="last")' || true)
[[ -n "$git_count" ]] || die "Cannot determine git commit count from GitHub response"

nix_pos=$(nix_attr meta.position)
nix_filename=${nix_pos%%:*}
nix_dir=$(dirname "$nix_filename")

src_info_path="${nix_dir}/src-info.json"
jq -n --arg rev "$new_rev" --argjson revCount "$git_count" \
      --argjson commitDate "$date" --arg hash "$new_hash" \
  '{rev:$rev, revCount:$revCount, commitDate:$commitDate, hash:$hash}' \
  > "$src_info_path"
log "Updated $src_info_path"

sed -i "s/${old_version}/${new_version}/" "$nix_filename"
log "Updated $nix_filename"

pubspec_lock_path="${nix_dir}/pubspec.lock.json"
old_pubspec_lock=$(cat "$pubspec_lock_path") || die "Failed to read $pubspec_lock_path"
new_pubspec_lock=$(yq -o=json eval . "${src_path}/pubspec.lock") || die "Failed to read pubspec.lock"
jq . <<<"$new_pubspec_lock" > "$pubspec_lock_path"
log "Updated $pubspec_lock_path"

git_hashes_path="${nix_dir}/git-hashes.json"
old_git_hashes=$(cat "$git_hashes_path") || die "Failed to read $git_hashes_path"

new_git_hashes='{}'
for name in $(jq -r '.packages | to_entries[] | select(.value.source == "git") | .key' <<<"$new_pubspec_lock"); do
  old_desc=$(jq -c --arg n "$name" '.packages[$n].description // empty' <<<"$old_pubspec_lock")
  new_desc=$(jq -c --arg n "$name" '.packages[$n].description' <<<"$new_pubspec_lock")
  if [[ "$old_desc" == "$new_desc" ]]; then
    hash=$(jq -r --arg n "$name" '.[$n]' <<<"$old_git_hashes")
    log "Reused existing git hash for dependency $name"
  else
    log "Updating git hash for dependency $name..."
    url=$(jq -r '.url' <<<"$new_desc")
    rev=$(jq -r '."resolved-ref"' <<<"$new_desc")
    hash=$(prefetch_git "$url" "$rev" | jq -r .hash)
  fi
  new_git_hashes=$(jq --arg n "$name" --arg h "$hash" '. + {($n): $h}' <<<"$new_git_hashes")
done
jq . <<<"$new_git_hashes" > "$git_hashes_path"
log "Updated $git_hashes_path"

finish "All done"
