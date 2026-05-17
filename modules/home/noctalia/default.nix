{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./plugins.nix
    ./settings.nix
    ./bar.nix
    ./niri.nix
  ];

  programs.noctalia-shell = {
    enable = true;
    package = pkgs.noctalia-shell;
  };
}
