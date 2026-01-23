# overlay/default.nix
final: prev:
let
  inherit (prev) lib;

  # List your overlay files here
  overlays = [
    (import ./packages.nix)
  ];
in
# This merges them while ensuring 'final' stays consistent across all of them
lib.composeManyExtensions overlays final prev
