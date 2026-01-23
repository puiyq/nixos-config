{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.asus-numberpad-driver.nixosModules.default ];

  hardware = {
    facter.reportPath = ../../facter.json;
    enableRedistributableFirmware = true;
    bluetooth.powerOnBoot = true;
  };
  services.asus-numberpad-driver = {
    enable = true;
    waylandDisplay = "wayland-1";
    config = {
      activation_time = "0.5";
      top_left_icon_activation_time = "0.5";
    };
  };
  local.hardware-clock.enable = false;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
