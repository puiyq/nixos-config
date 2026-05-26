{
  inputs,
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  imports = [
    ./settings.nix
    ./window-rules.nix
    ./binds.nix
    inputs.niri-nix.homeModules.default
  ];
  wayland.windowManager.niri = {
    enable = true;
    package = osConfig.programs.niri.package;
    settings.xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
  };
}
