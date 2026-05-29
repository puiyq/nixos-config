{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.selector4nix.overlays.default
          inputs.nix-cachyos-kernel.overlays.pinned
          inputs.chaotic.overlays.cache-friendly
          inputs.self.overlays.default
        ];
        config = {
          allowUnfree = true;
          # rocmSupport = true;
        };
      };
    };
}
