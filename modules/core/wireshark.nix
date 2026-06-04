{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    usbmon.enable = true;
  };
  boot.kernelModules = lib.mkIf config.programs.wireshark.usbmon.enable [ "usbmon" ];
}
