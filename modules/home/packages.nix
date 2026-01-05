{
  home.packages = [ ];
  programs.distrobox.enable = true;
  services = {
    network-manager-applet.enable = true;
    hyprpolkitagent.enable = true;
  };
}
