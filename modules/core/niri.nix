{ pkgs, lib, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  xdg.portal.config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce [
    "oo7-portal"
    "gnome-keyring"
  ];

  environment.systemPackages = [ pkgs.xdg-utils ];
}
