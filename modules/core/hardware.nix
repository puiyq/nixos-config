{ pkgs, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics.enable = true;
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
  chaotic.mesa-git = {
    enable = true;
    fallbackSpecialisation = false;
    extraPackages = with pkgs.mesa_git; [
      opencl
    ];
  };
  local.hardware-clock.enable = false;
}
