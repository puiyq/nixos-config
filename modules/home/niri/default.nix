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

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    TERMINAL = "footclient";
  };
}
