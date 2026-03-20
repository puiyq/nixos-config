{
  config,
  osConfig,
  ...
}:
{
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../assets/images/wallpapers;
      recursive = true;
    };
    ".face".source = ../../assets/images/face.png;
    ".wakatime.cfg".source =
      config.lib.file.mkOutOfStoreSymlink
        osConfig.sops.templates."wakatime".path;
  };
}
