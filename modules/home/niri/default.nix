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
  programs.niri.settings = {
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
      center-focused-column = "never";
      always-center-single-column = true;
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 0.5; }
        { proportion = 2.0 / 3.0; }
      ];
      default-column-width = {
        proportion = 1.0;
      };
    };

    gestures.hot-corners.enable = false;

    xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite-unstable;

    clipboard.disable-primary = true;
    prefer-no-csd = true;
    screenshot-path = "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H-%M-%S.png";

    hotkey-overlay.skip-at-startup = true;

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
            r = 8.0;
          in
          {
            bottom-left = r;
            bottom-right = r;
            top-left = r;
            top-right = r;
          };
      }
      {
        matches = [ { app-id = "^zen(-twilight)?$"; } ];
        default-column-width.proportion = 2.0 / 3.0;
      }
      {
        matches = [
          { app-id = "^com\.mitchellh\.ghostty$"; }
          { app-id = "^foot(client)?$"; }
        ];
        default-column-width.proportion = 0.5;
      }
      {
        matches = [ { app-id = "^discord$"; } ];
        default-column-width.proportion = 0.5;
      }
      {
        matches = [
          { app-id = "^pavucontrol$"; }
          { app-id = "^com\\.saivert\\.pwvucontrol$"; }
        ];
        open-floating = true;
      }
      {
        matches = [ { title = "^Picture-in-Picture$"; } ];
        open-floating = true;
        block-out-from = "screencast";
      }
    ];

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
        "Mod+Return".action.spawn = [
          "footclient"
        ];
        "Mod+W".action.spawn = "zen";
        "Mod+D".action.spawn = "discord";
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

        "Mod+S".action.screenshot = { };
        "Mod+Q".action.close-window = { };
        "Mod+F".action.fullscreen-window = { };
        "Mod+Shift+F".action.toggle-window-floating = { };
        "Mod+O" = {
          action = toggle-overview;
          repeat = false;
        };
        "Mod+V" = {
          action.spawn = noctalia "launcher clipboard";
          hotkey-overlay.title = "clipboard history";
          repeat = false;
        };

        # Navigation (Vim & Arrows)
        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-window-or-workspace-down;
        "Mod+Up".action = focus-window-or-workspace-up;

        # Movement
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;

        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        # Resizing
        "Mod+Ctrl+Left".action.set-column-width = "-10%";
        "Mod+Ctrl+Right".action.set-column-width = "+10%";
        "Mod+Ctrl+Up".action.set-window-height = "-10%";
        "Mod+Ctrl+Down".action.set-window-height = "+10%";
        "Mod+Ctrl+H".action.set-column-width = "-10%";
        "Mod+Ctrl+L".action.set-column-width = "+10%";
        "Mod+Ctrl+J".action.set-window-height = "-10%";
        "Mod+Ctrl+K".action.set-window-height = "+10%";
        "Mod+M".action = maximize-column;
        "Mod+Space".action = switch-preset-column-width;
        "Mod+Shift+Space".action = switch-preset-window-height;

        # Workspace Navigation (Numbers)
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        # Media Keys
        "XF86AudioMute" = {
          action.spawn = noctalia "volume muteOutput";
          repeat = false;
        };
        "XF86AudioMicMute" = {
          action.spawn = noctalia "volume muteInput";
          repeat = false;
        };
        "XF86MonBrightnessDown" = {
          action.spawn = noctalia "brightness decrease";
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action.spawn = noctalia "brightness increase";
          allow-when-locked = true;
        };
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";

        "Mod+Slash".action = show-hotkey-overlay;
      };
  };
}
