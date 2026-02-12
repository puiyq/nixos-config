{
  lib,
  config,
  pkgs,
  ...
}:
{

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    TERMINAL = "footclient";
  };
  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb.layout = "us";
          repeat-delay = 300;
          repeat-rate = 50;
        };
        touchpad = {
          tap = true;
          dwt = true; # Disable-while-typing
          natural-scroll = true;
          scroll-factor = 0.8;
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
      };

      outputs."eDP-1" = {
        scale = 1.5;
        mode = {
          width = 1920;
          height = 1200;
          refresh = 60.0;
        };
      };

      layout = {
        gaps = 8;
        border.enable = false;
        center-focused-column = "never";
        always-center-single-column = true;
        background-color = "transparent";
        default-column-width.proportion = 1.0;
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 0.5; }
          { proportion = 2.0 / 3.0; }
          { proportion = 1.0; }
        ];
      };

      gestures.hot-corners.enable = false;

      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite-unstable;

      clipboard.disable-primary = true;
      prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H-%M-%S.png";

      hotkey-overlay = {
        skip-at-startup = true;
        hide-not-bound = true;
      };

      overview.workspace-shadow.enable = false;

      layer-rules = [
        {
          matches = [ { namespace = "^noctalia-wallpaper.*"; } ];
          place-within-backdrop = true;
        }
      ];

      animations = {
        window-open.kind.easing = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };

        window-close.kind.easing = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };

        window-movement.kind.easing = {
          duration-ms = 200;
          curve = "ease-out-cubic";
        };

        workspace-switch.kind.spring = {
          damping-ratio = 0.8;
          stiffness = 1000;
          epsilon = 0.0001;
        };
      };

      window-rules = [
        {
          draw-border-with-background = false;
          clip-to-geometry = true;
          geometry-corner-radius =
            let
              r = 16.0;
            in
            {
              bottom-left = r;
              bottom-right = r;
              top-left = r;
              top-right = r;
            };
        }
        {
          matches = [
            { app-id = "^io\.github\.tobagin\.karere$"; }
            { app-id = "^jetbrains-idea$"; }
            { app-id = "^zen(-twilight|-beta)?$"; }
            { app-id = "^org\.gnome\.Fractal$"; }
            { app-id = "^spotify$"; }
          ];
          opacity = 0.95;
        }
        {
          matches = [
            {
              app-id = "^com\.mitchellh\.ghostty$";
              is-active = true;
            }
            {
              app-id = "^foot(client)?$";
              is-active = true;
            }
          ];
          opacity = 0.85;
        }
        {
          matches = [
            {
              app-id = "^com\.mitchellh\.ghostty$";
              is-active = false;
            }
            {
              app-id = "^foot(client)?$";
              is-active = false;
            }
          ];
          opacity = 0.60;
        }
        {
          matches = [
            { app-id = "^com\.mitchellh\.ghostty$"; }
            { app-id = "^foot(client)?$"; }
          ];
          default-column-width.proportion = 0.5;
        }
        {
          matches = [
            { app-id = "^pavucontrol$"; }
            { app-id = "^com\.saivert\.pwvucontrol$"; }
          ];
          open-floating = true;
        }
        {
          matches = [ { title = "^Picture-in-Picture$"; } ];
          open-floating = true;
          block-out-from = "screencast";
        }
      ];

      switch-events = {
        lid-close.action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "sessionMenu"
          "lockAndSuspend"
        ];
      };

      binds =
        let
          noctalia =
            cmd:
            [
              "noctalia-shell"
              "ipc"
              "call"
            ]
            ++ (lib.splitString " " cmd);
        in
        with config.lib.niri.actions;
        {
          "Mod+Return" = {
            action.spawn = [ "footclient" ];
            hotkey-overlay.title = "Terminal";
          };
          "Mod+W" = {
            action.spawn = "zen";
            hotkey-overlay.title = "Browser";
          };
          "Mod+Y" = {
            hotkey-overlay.title = "Yazi";
            repeat = false;
            action.spawn = [
              "footclient"
              "-e"
              "yazi"
            ];
          };

          "Mod+Shift+Return" = {
            action.spawn = noctalia "launcher toggle";
            hotkey-overlay.title = "Launcher";
            repeat = false;
          };

          "Print".action.screenshot = { };
          "Mod+Q".action.close-window = { };
          "Mod+F".action.fullscreen-window = { };
          "Mod+Shift+F".action.toggle-window-floating = { };
          "Mod+Shift+O" = {
            action = toggle-overview;
            hotkey-overlay.title = "Toggle Overview";
            repeat = false;
          };
          "Mod+V" = {
            action.spawn = noctalia "launcher clipboard";
            hotkey-overlay.title = "clipboard history";
            repeat = false;
          };
          "Mod+S" = {
            action.spawn = noctalia "systemMonitor toggle";
            hotkey-overlay.title = "System Monitor";
            repeat = false;
          };

          # Navigation (Vim+Arrows)
          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+J".action = focus-window-or-workspace-down;
          "Mod+K".action = focus-window-or-workspace-up;
          "Mod+Left" = {
            action = focus-column-left;
            hotkey-overlay.title = "Focus Column Left";
          };
          "Mod+Right" = {
            action = focus-column-right;
            hotkey-overlay.title = "Focus Column Right";
          };
          "Mod+Down" = {
            action = focus-window-or-workspace-down;
            hotkey-overlay.title = "Focus Window Or Workspace Down";
          };
          "Mod+Up" = {
            action = focus-window-or-workspace-up;
            hotkey-overlay.title = "Focus Window Or Workspace Up";
          };

          # Movement (Vim+Arrows)
          "Mod+Shift+H".action = move-column-left;
          "Mod+Shift+L".action = move-column-right;
          "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
          "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
          "Mod+Shift+Left" = {
            action = move-column-left;
            hotkey-overlay.title = "Move Column Left";
          };
          "Mod+Shift+Right" = {
            action = move-column-right;
            hotkey-overlay.title = "Move Column Right";
          };
          "Mod+Shift+Down" = {
            action = move-window-down-or-to-workspace-down;
            hotkey-overlay.title = "Move Window Down Or To Workspace Down";
          };
          "Mod+Shift+Up" = {
            action = move-window-up-or-to-workspace-up;
            hotkey-overlay.title = "Move Window Up Or To Workspace Up";
          };

          "Mod+BracketLeft".action = consume-or-expel-window-left;
          "Mod+BracketRight".action = consume-or-expel-window-right;
          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;

          # Resizing (Vim+Arrows)
          "Mod+Ctrl+H".action.set-column-width = "-10%";
          "Mod+Ctrl+L".action.set-column-width = "+10%";
          "Mod+Ctrl+J".action.set-window-height = "-10%";
          "Mod+Ctrl+K".action.set-window-height = "+10%";
          "Mod+Ctrl+Left" = {
            action.set-column-width = "-10%";
            hotkey-overlay.title = "Decrease Column Width";
          };
          "Mod+Ctrl+Right" = {
            action.set-column-width = "+10%";
            hotkey-overlay.title = "Increase Column Width";
          };
          "Mod+Ctrl+Up" = {
            action.set-window-height = "-10%";
            hotkey-overlay.title = "Decrease Window Height";
          };
          "Mod+Ctrl+Down" = {
            action.set-window-height = "+10%";
            hotkey-overlay.title = "Increase Window Height";
          };

          "Mod+M".action = maximize-column;
          "Mod+Space".action = switch-preset-column-width;
          "Mod+Shift+Space".action = switch-preset-window-height;

          # Media Keys
          "XF86AudioMute" = {
            action.spawn = noctalia "volume muteOutput";
            hotkey-overlay.title = "Mute Output";
            repeat = false;
          };
          "XF86AudioMicMute" = {
            action.spawn = noctalia "volume muteInput";
            hotkey-overlay.title = "Mute Input";
            repeat = false;
          };
          "XF86MonBrightnessDown" = {
            action.spawn = noctalia "brightness decrease";
            hotkey-overlay.title = "Brightness Down";
            allow-when-locked = true;
          };
          "XF86MonBrightnessUp" = {
            action.spawn = noctalia "brightness increase";
            hotkey-overlay.title = "Brightness Up";
            allow-when-locked = true;
          };
          "XF86AudioRaiseVolume" = {
            action.spawn = noctalia "volume increase";
            hotkey-overlay.title = "Volume Up";
          };
          "XF86AudioLowerVolume" = {
            action.spawn = noctalia "volume decrease";
            hotkey-overlay.title = "Volume Down";
          };

          "Mod+Shift+Slash" = {
            action.spawn = noctalia "plugin:keybind-cheatsheet toggle";
            hotkey-overlay.title = "Keybind Cheatsheet";
          };
        };
    };
  };
}
