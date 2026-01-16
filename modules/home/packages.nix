{
  home.packages = [ ];
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../assets/images/wallpapers;
      recursive = true;
    };
    ".face".source = ../../assets/images/face.png;
  };
  programs = {
    distrobox.enable = true;
    hyprshot = {
      enable = false;
      saveLocation = "$HOME/Pictures/Screenshots";
    };
  };
}
