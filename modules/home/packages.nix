{
  home.packages = [ ];
  programs.distrobox.enable = true;
  services = {
    network-manager-applet.enable = true;
    hyprpolkitagent.enable = true;
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../assets/images/wallpapers;
      recursive = true;
    };
    ".face".source = ../../assets/images/face.png;
  };
  };
}
