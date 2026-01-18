{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.asus-numberpad-driver.nixosModules.default ];

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics.enable = true;
  };
  services.asus-numberpad-driver = {
    enable = true;
    waylandDisplay = "wayland-1";
    config = {
      activation_time = "0.1";
      top_left_icon_activation_time = "0.5";
    };
  };
  local.hardware-clock.enable = false;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
