{
  programs.vicinae = {
    enable = false;
    systemd.enable = true;
    settings = {
      "$schema" = "https://vicinae.com/schemas/config.json";
    };
  };
}
