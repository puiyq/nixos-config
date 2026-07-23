{ osConfig, ... }:
{
  imports = [
    ./settings.nix
    ./window-rules.nix
    ./binds.nix
  ];
  wayland.windowManager.niri = {
    enable = true;
    package = osConfig.programs.niri.package;
    portalPackage = null;
  };
}
