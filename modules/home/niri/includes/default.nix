{
  xdg.configFile."niri/includes" = {
    source = builtins.filterSource (path: type: baseNameOf path != "default.nix") ./.;
    recursive = true;
  };
  programs.niri.settings.includes = [
    { path = "includes/blur.kdl"; }
  ];
}
