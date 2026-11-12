# overlay/default.nix
final: prev:
let
  inherit (prev) lib;

  overlays = [
    (import ./patches)
    (import ./hack.nix)
  ];
in
lib.composeManyExtensions overlays final prev
