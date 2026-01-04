{
  services.hyprpaper = {
    enable = true;
    #settings = ''
    # wallpaper {
    #    path = ~/Pictures/Wallpapers/AnimeGirlNightSky.jpg
    #}
    #'';
  };
  home.file = {
    ".config/hypr/hyprpaper.conf" = {
      text = ''
        splash = false

        wallpaper {
            monitor = eDP-1
            path = ~/Pictures/Wallpapers/AnimeGirlNightSky.jpg
            fit_mode = cover
        }
      '';
    };
  };
}
