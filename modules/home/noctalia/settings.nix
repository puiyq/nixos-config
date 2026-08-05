{
  pkgs,
  lib,
  host,
  ...
}:
{
  programs.noctalia = {
    enable = true;
    package = pkgs.noctalia;
    systemd.enable = true;

    settings = {
      accessibility = lib.mkIf (host == "roselia") {
        ui_scale = 1.35;
      };

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
            "group:g3"
            "clock"
            "session"
          ];
          font_weight = 700;
          margin_edge = 5;
          margin_ends = 0;
          scale = if host == "roselia" then 1.55 else 1.15;
          shadow = false;
          start = [
            "tray"
            "group:g2"
            "group:g1"
          ];
          thickness = if host == "roselia" then 60 else 45;
          widget_spacing = 8;

          capsule_group = [
            {
              fill = "surface_variant";
              id = "g1";
              members = [
                "cpu"
                "ram"
                "temp"
                "network_rx"
              ];
              opacity = 1.0;
              padding = 6.0;
            }
            {
              fill = "surface_variant";
              id = "g2";
              members = [
                (lib.mkIf (host == "popipa") "network")
                "bluetooth"
              ];
              opacity = 1.0;
              padding = 6.0;
            }
            {
              fill = "surface_variant";
              id = "g3";
              members = [
                "volume"
                "brightness"
                "battery"
              ];
              opacity = 1.0;
              padding = 6.0;
            }
          ];
        };
      };

      brightness = lib.mkIf (host == "roselia") {
        enable_ddcutil = true;
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
        fingerprint = false;
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
        auto_update = true;
        enabled = [
          "noctalia/screen_recorder"
          "noctalia/kaomoji"
        ];

        source = [
          {
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
        ];
      };

      shell = {
        avatar_path = "~/Pictures/face.png";
        clipboard_image_action_command = "satty -f -";
        date_format = "{:%a, %b %-d}";
        lang = "zh-Hans";
        launch_apps_as_systemd_services = true;
        polkit_agent = true;
        screen_time_enabled = true;
        settings_show_advanced = true;
        telemetry_enabled = false;

        greeter_sync = {
          auto_sync = true;
        };

        launcher = {
          categories = false;
          fetch_exchange_rates = false;
          providers = {
            calculator = {
              global = false;
            };
          };
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
        mode = "dark";
        source = "custom";
      };

      wallpaper =
        let
          path =
            if host == "roselia" then
              "/home/yukina/Pictures/Wallpapers/Win11Girl_2k.png"
            else
              "~/Pictures/Wallpapers/Win11Girl.png";
        in
        {
          default = {
            inherit path;
          };
          last = {
            inherit path;
          };
          monitors =
            if host == "roselia" then
              {
                "DP-1" = {
                  inherit path;
                };
              }
            else
              {
                "eDP-1" = {
                  inherit path;
                };
              };
        };

      widget = {
        # keep-sorted start block=yes
        clock = {
          format = "{:%H:%M} {:%a, %b %-d}";
        };
        cpu = {
          visualization = "none";
        };
        network = {
          show_label = false;
        };
        network_rx = {
          visualization = "none";
        };
        network_tx = {
          visualization = "none";
        };
        ram = {
          visualization = "none";
          stat = "ram_pct";
        };
        recorder = {
          type = "noctalia/screen_recorder:recorder";
        };
        spacer = {
          length = 20.0;
        };
        temp = {
          visualization = "none";
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
