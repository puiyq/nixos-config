{ pkgs, ... }:
{
  hardware.graphics.enable32Bit = true;
  chaotic.mesa-git.extraPackages32 = with pkgs.mesa32_git; [
    opencl
  ];
}
