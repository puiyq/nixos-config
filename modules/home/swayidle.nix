{ pkgs, lib, ... }:
{
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 180; # 3min: turn off keyboard backlight
        command = "${lib.getExe pkgs.brightnessctl} --save --device=asus::kbd_backlight set 0";
        resumeCommand = "${lib.getExe pkgs.brightnessctl} --restore --device=asus::kbd_backlight";
      }
      {
        timeout = 600; # 10min: dim screen as warning
        command = "${lib.getExe pkgs.brightnessctl} --save --device=amdgpu_bl1 set 30%";
        resumeCommand = "${lib.getExe pkgs.brightnessctl} --restore --device=amdgpu_bl1";
      }
    ];
  };
}
