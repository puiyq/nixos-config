{
  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "noctalia ipc call lockScreen lock";
          before_sleep_cmd = "loginctl lock-session";
        };

        listener = [
          {
            timeout = 180; # 3 minutes
            on-timeout = "brightnessctl --save --device=asus::kbd_backlight set 0"; # turn off keyboard backlight
            on-resume = "brightnessctl --restore --device=asus::kbd_backlight"; # turn on keyboard backlight
          }
          {
            timeout = 900; # 15 minutes
            on-timeout = "noctalia ipc call lockScreen lock";
          }
          {
            timeout = 1200; # 20 minutes
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
