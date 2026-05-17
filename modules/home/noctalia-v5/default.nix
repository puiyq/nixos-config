{
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia-v5.homeModules.default
    ./niri.nix
    ./settings.nix
    ./wallpaper.nix
  ];
}
