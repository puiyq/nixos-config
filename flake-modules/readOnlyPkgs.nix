{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.self.overlays.default
          inputs.selector4nix.overlays.default
          inputs.nix-cachyos-kernel.overlays.pinned
        ];
        config = {
          allowUnfree = true;
          # rocmSupport = true;
        };
      };
    };
}
