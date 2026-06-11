{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt =
    { pkgs, ... }:
    {
      projectRootFile = "flake.nix";
      programs = {
        # keep-sorted start block=yes
        biome.enable = true;
        deadnix.enable = true;
        keep-sorted.enable = true;
        nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rs;
        };
        rustfmt.enable = true;
        statix.enable = true;
        taplo.enable = true;
        yamlfmt.enable = true;
        # keep-sorted end
      };
    };
}
