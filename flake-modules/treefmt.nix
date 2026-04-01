{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    programs = {
      # keep-sorted start
      biome.enable = true;
      deadnix.enable = true;
      keep-sorted.enable = true;
      nixfmt.enable = true;
      shfmt.enable = true;
      statix.enable = true;
      yamlfmt.enable = true;
      # keep-sorted end
    };
  };
}
