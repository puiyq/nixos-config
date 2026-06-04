{ config, ... }:
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar.default = {
        background_opacity = 0.0;
        thickness = 45;
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
        sidebar = "full";
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

      shell = {
        avatar_path = "/home/kasumi/.face";
        clipboard_image_action_command = "satty -f -";
        date_format = "{:%a, %b %-d}";
        polkit_agent = true;
        settings_show_advanced = false;
        telemetry_enabled = false;
        launch_apps_as_systemd_services = true;
        screen_time_enabled = true;

        panel = {
          launcher_categories = false;
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
        builtin = "Catppuccin";
        community_palette = "Catppuccin Lavender";
        custom_palette = "Catppuccin Mocha";
        source = "custom";
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

      location = {
        auto_locate = true;
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

    customPalettes = {
      "Catppuccin Mocha" = builtins.fromJSON (builtins.readFile ./catppuccin_mocha.json);
      stylix = with config.lib.stylix.colors.withHashtag; {
        dark = {
          mPrimary = base0D;
          mOnPrimary = base00;
          mSecondary = base0E;
          mOnSecondary = base00;
          mTertiary = base0C;
          mOnTertiary = base00;
          mError = base08;
          mOnError = base00;
          mSurface = base00;
          mOnSurface = base05;
          mHover = base0C;
          mOnHover = base00;
          mSurfaceVariant = base01;
          mOnSurfaceVariant = base04;
          mOutline = base03;
          mShadow = base00;
          terminal = {
            foreground = base05;
            background = base00;
            selectionFg = base05;
            selectionBg = base03;
            cursorText = base00;
            cursor = base06;
            normal = {
              black = base00;
              red = base08;
              green = base0B;
              yellow = base0A;
              blue = base0D;
              magenta = base0E;
              cyan = base0C;
              white = base05;
            };
            bright = {
              black = base03;
              red = base09;
              green = base0B;
              yellow = base0A;
              blue = base0D;
              magenta = base0E;
              cyan = base0C;
              white = base07;
            };
          };
        };
      };
    };
  };
}
