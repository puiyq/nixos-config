{
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "noctalia-shell ipc call lockScreen lock";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener = [
          {
            timeout = 180; # 3min: turn off keyboard backlight
            on-timeout = "brightnessctl --save --device=asus::kbd_backlight set 0";
            on-resume = "brightnessctl --restore --device=asus::kbd_backlight";
          }
          {
            timeout = 600; # 10min: dim screen as warning
            on-timeout = "brightnessctl --save --device=amdgpu_bl1 set 30%";
            on-resume = "brightnessctl --restore --device=amdgpu_bl1";
          }
          {
            timeout = 720; # 12min: lock session
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 1800; # 30min: suspend
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
