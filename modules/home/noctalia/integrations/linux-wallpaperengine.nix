{
  services = {
    linux-wallpaperengine = {
      enable = false;
      wallpapers = [
        {
          audio.silent = true;
          monitor = "eDP-1";
          scaling = "fill";
          extraOptions = [ "--fullscreen-pause-only-active" ];
          wallpaperId = "3525342822";
        }
      ];
    };
  };
}
