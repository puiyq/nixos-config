{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      overlays = [
        inputs.selector4nix.overlays.default
        inputs.chaotic.overlays.cache-friendly
        inputs.lycosa.overlays.default
        inputs.self.overlays.default
      ];

      mkPkgs =
        extraConfig:
        import inputs.nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
          }
          // extraConfig;
        };
    in
    {
      _module.args = {
        pkgs = mkPkgs { };
        rocmPkgs = mkPkgs {
          rocmSupport = true;
        };
      };
    };
}
