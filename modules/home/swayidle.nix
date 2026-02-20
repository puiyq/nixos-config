{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.swayidle = {
    enable = true;

    events = {
      before-sleep = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
      lock = "${lib.getExe config.programs.noctalia-shell.package} ipc call lockScreen lock";
    };

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
      {
        timeout = 720; # 12min: lock session
        command = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
      }
      {
        timeout = 1800; # 30min: suspend
        command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
      }
    ];
  };
}
