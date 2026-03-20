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
  ];

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      calendarSupport = true;
    };
  };
}
