{
  # Waybar Settings
  clock24h = true;

  # Program Options
  browser = "zen"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "ghostty"; # Set Default System Terminal

  # Enable NFS
  enableNFS = false;

  # Enable Printing Support
  printEnable = false;

  # Set Stylix Image
  stylixImage = ../../wallpapers/AnimeGirlNightSky.jpg;

  # Set Waybar
  # Includes alternates such as:
  # Just uncomment the one you want and comment out the others

  #waybarChoice = ../../modules/home/waybar/waybar-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-nekodyke.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;

  # Set Animation style
  # Available options are:
  # animations-def.nix  (standard)
  # animations-end4.nix (end-4 project)
  # animations-dynamic.nix (ml4w project)
  # animations-moving.nix (ml4w project)
  # Just change the name after the - and rebuild
  animChoice = ../../modules/home/hyprland/animations-end4.nix;

  # Enable Thunar GUI File Manager
  thunarEnable = true;
}
