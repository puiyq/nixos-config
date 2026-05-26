{ inputs, pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./window-rules.nix
    ./binds.nix
    ./includes
    inputs.niri.homeModules.niri
  ];
  programs.niri.package = pkgs.niri;
}
