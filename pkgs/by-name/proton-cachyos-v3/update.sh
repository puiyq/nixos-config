#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eo pipefail

repo="https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest"
version="$(curl -sL "$repo" | jq -r '.tag_name' | sed 's/^cachyos-//')"

update-source-version proton-cachyos-v3 "$version"
