# overlay/default.nix
final: prev:
let
  inherit (prev) lib;

  overlays = [
    (import ./packages.nix)
    (import ./patches)
    (import ./hack.nix)
  ];
in
# This merges them while ensuring 'final' stays consistent across all of them
lib.composeManyExtensions overlays final prev
