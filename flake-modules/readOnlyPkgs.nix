{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.self.overlays.default
          inputs.nix-cachyos-kernel.overlays.default
        ];
        config = {
          allowUnfree = true;
          rocmSupport = true;
        };
      };
    };
}
