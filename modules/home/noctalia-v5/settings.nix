{
  programs.noctalia = {
    enable = true;

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
        margin_edge = 5;
        margin_ends = 0;
        scale = 1.15;
        shadow = false;
        start = [
          "bluetooth"
          "tray"
          "cpu"
          "ram"
          "temp"
          "audio_visualizer"
        ];
      };

      control_center = {
        compact = false;
        shortcuts = [
          { type = "caffeine"; }
          { type = "notification"; }
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
        pre_action_fade_seconds = 5.0;
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
        settings_show_advanced = true;
        telemetry_enabled = false;
        panel = {
          attach_control_center = false;
          attach_wallpaper = false;
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
      };

      weather = {
        address = "Kuching";
      };

      widget = {
        audio_visualizer = {
          show_when_idle = false;
        };
        clock = {
          format = "{:%H:%M} {:%a, %b %-d}";
        };
        cpu = {
          display = "text";
          label_min_width = 0.0;
        };
        media = {
          title_scroll = "always";
        };
        notifications = {
          hide_when_no_unread = true;
        };
        ram = {
          display = "text";
          stat = "ram_pct";
        };
        spacer = {
          length = 20.0;
        };
        temp = {
          display = "text";
        };
        tray = {
          drawer = true;
        };
        workspaces = {
          anchor = true;
        };
      };
    };
  };
}
