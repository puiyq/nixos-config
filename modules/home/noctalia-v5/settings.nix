{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar.default = {
        attach_panels = false;
        background_opacity = 0.0;
        capsule = true;
        center = [
          "workspaces"
          "control-center"
        ];
        end = [
          "notifications"
          "volume"
          "brightness"
          "battery"
          "spacer"
          "clock"
          "session"
        ];
        font_weight = 700;
        margin_edge = 5;
        margin_ends = 0;
        scale = 1.15;
        shadow = false;
        start = [
          "tray"
          "bluetooth"
          "cpu"
          "ram"
          "temp"
          "network_rx"
          "network_tx"
        ];
      };

      control_center = {
        compact = false;
        shortcuts = [
          { type = "caffeine"; }
          { type = "notification"; }
          { type = "power_profile"; }
        ];
      };

      desktop_widgets = {
        enabled = false;
      };

      idle = {
        behavior_order = [
          "lock"
          "suspend"
        ];
        pre_action_fade_seconds = 10.0;
        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 720;
          };
          suspend = {
            action = "suspend";
            enabled = true;
            lock_before_suspend = true;
            timeout = 1800;
          };
        };
      };

      shell = {
        avatar_path = "/home/kasumi/.face";
        date_format = "{:%a, %b %-d}";
        polkit_agent = true;
        settings_show_advanced = false;
        telemetry_enabled = false;
        screen_time_enabled = true;

        panel = {
          attach_control_center = false;
          attach_wallpaper = false;
          control_center_placement = "floating";
          session_placement = "centered";
          wallpaper_placement = "floating";
        };

        session = {
          actions = [
            {
              action = "lock";
              enabled = true;
              variant = "default";
            }
            {
              action = "logout";
              enabled = true;
              variant = "default";
            }
            {
              action = "suspend";
              enabled = true;
              variant = "default";
            }
            {
              action = "reboot";
              enabled = true;
              variant = "default";
            }
            {
              action = "shutdown";
              enabled = true;
              variant = "destructive";
            }
          ];
        };
      };

      theme = {
        community_palette = "Catppuccin Lavender";
        source = "community";
      };

      wallpaper = {
        directory = "/home/kasumi/Pictures/Wallpapers";
        default = {
          path = "/home/kasumi/Pictures/Wallpapers/AnimeGirlNightSky.jpg";
        };
        last = {
          path = "/home/kasumi/Pictures/Wallpapers/AnimeGirlNightSky.jpg";
        };
        monitors.eDP-1 = {
          path = "/home/kasumi/Pictures/Wallpapers/AnimeGirlNightSky.jpg";
        };
      };

      weather = {
        address = "Kuching";
      };

      widget = {
        # keep-sorted start block=yes
        battery = {
          hide_when_plugged = true;
        };
        bongocat = {
          input_device = "/dev/input/event3";
          script = "scripts/bongocat.lua";
          type = "scripted";
        };
        clock = {
          format = "{:%H:%M} {:%a, %b %-d}";
        };
        cpu = {
          display = "text";
          label_min_width = 0.0;
        };
        network_rx = {
          display = "text";
        };
        network_tx = {
          display = "text";
        };
        notifications = {
          hide_when_no_unread = true;
        };
        ram = {
          display = "text";
          stat = "ram_pct";
        };
        screen_recorder = {
          script = "scripts/screen_recorder.lua";
          type = "scripted";
        };
        spacer = {
          length = 20.0;
        };
        temp = {
          display = "text";
        };
        workspaces = {
          anchor = true;
        };
        # keep-sorted end
      };
    };
  };
}
