{ inputs, ... }:
{
  flake = {
    overlays.default =
      _final: prev:
      (import ../pkgs {
        pkgs = prev;
        inherit (prev) lib;
      })
      // (import ../overlay/default.nix _final prev)
      // (inputs.niri.overlays.niri _final prev);
  };
}
