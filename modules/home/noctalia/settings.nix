{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        default = {
          background_opacity = 0.0;
          capsule = true;
          center = [
            "recorder"
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
          thickness = 45;
        };
      };

      calendar = {
        enabled = true;
        account.personal_google.type = "google";
      };

      control_center = {
        sidebar = "full";
        sidebar_section = "full";

        shortcuts = [
          { type = "caffeine"; }
          { type = "notification"; }
          { type = "power_profile"; }
          { type = "noctalia/screen_recorder:toggle"; }
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
        pre_action_fade_seconds = 30.0;
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

      location = {
        auto_locate = true;
      };

      lockscreen = {
        blur_intensity = 0.0;
        tint_intensity = 0.0;
      };

      osd = {
        position = "top_right";
      };

      plugin_settings."noctalia/screen_recorder" = {
        copy_to_clipboard = true;
        directory = "~/Videos/Recordings";
        hide_inactive = true;
        resolution = "original";
        video_codec = "av1";
        video_source = "portal";
      };

      plugins = {
        enabled = [
          "noctalia/screen_recorder"
          "noctalia/kaomoji"
        ];

        source = [
          {
            auto_update = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            auto_update = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
        ];
      };

      shell = {
        avatar_path = "/home/kasumi/.face";
        clipboard_image_action_command = "satty -f -";
        date_format = "{:%a, %b %-d}";
        lang = "zh-Hans";
        launch_apps_as_systemd_services = true;
        polkit_agent = true;
        screen_time_enabled = true;
        settings_show_advanced = true;
        telemetry_enabled = false;

        launcher = {
          categories = false;
        };

        panel = {
          control_center_placement = "floating";
          session_placement = "floating";
          session_position = "center";
          transparency_mode = "soft";
          wallpaper_placement = "floating";
        };

        screen_corners = {
          enabled = true;
          size = 16;
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
        builtin = "Catppuccin";
        community_palette = "Catppuccin Lavender";
        custom_palette = "Catppuccin Mocha";
        source = "custom";
      };

      wallpaper = {
        directory = "/home/kasumi/Pictures/Wallpapers";
        default = {
          path = "/home/kasumi/Pictures/Wallpapers/Win11Girl.png";
        };
        last = {
          path = "/home/kasumi/Pictures/Wallpapers/Win11Girl.png";
        };
        monitors.eDP-1 = {
          path = "/home/kasumi/Pictures/Wallpapers/Win11Girl.png";
        };
      };

      widget = {
        # keep-sorted start block=yes
        battery = {
          hide_when_plugged = true;
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
        recorder = {
          type = "noctalia/screen_recorder:recorder";
        };
        spacer = {
          length = 20.0;
        };
        temp = {
          display = "text";
        };
        tray = {
          detached_panel = true;
          drawer = true;
        };
        workspaces = {
          anchor = true;
        };
        # keep-sorted end
      };
    };

    customPalettes = {
      "Catppuccin Mocha" = builtins.fromJSON (builtins.readFile ./catppuccin_mocha.json);
    };
  };
}
