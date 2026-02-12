{ ... }:
{
  imports = [
    ./settings.nix
    ./window-rules.nix
    ./binds.nix
  ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    TERMINAL = "footclient";
  };
}
