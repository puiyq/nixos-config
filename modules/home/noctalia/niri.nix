{ pkgs, lib, ... }:
{
  programs.niri.settings = {
    layer-rules = [
      {
        matches = [ { namespace = "linux-wallpaperengine"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "^noctalia-wallpaper"; } ];
        opacity = 0.0;
      }
    ];

    window-rules = [
      {
        matches = [ { app-id = "dev.noctalia.Noctalia.Settings"; } ];
        open-floating = true;
        default-column-width = {
          fixed = 1080;
        };
        default-window-height = {
          fixed = 740;
        };
      }
    ];

    debug.honor-xdg-activation-with-invalid-serial = [ ];

    switch-events = {
      lid-close.action.spawn = [
        "${pkgs.writeShellScript "lid-close-action" ''
          noctalia msg screen-lock
          noctalia msg suspend
        ''}"
      ];
    };

    binds =
      let
        noctalia =
          cmd:
          [
            "noctalia"
            "msg"
          ]
          ++ (lib.splitString " " cmd);
      in
      {
        "Mod+Shift+Return" = {
          action.spawn = noctalia "panel-toggle launcher";
          hotkey-overlay.title = "Launcher";
          repeat = false;
        };

        "Mod+V" = {
          action.spawn = noctalia "panel-toggle clipboard";
          hotkey-overlay.title = "clipboard history";
          repeat = false;
        };

        # Media Keys
        "XF86AudioMute" = {
          action.spawn = noctalia "volume-mute";
          hotkey-overlay.title = "Mute Output";
          repeat = false;
        };
        "XF86AudioMicMute" = {
          action.spawn = noctalia "mic-mute";
          hotkey-overlay.title = "Mute Input";
          repeat = false;
        };
        "XF86MonBrightnessDown" = {
          action.spawn = noctalia "brightness-down";
          hotkey-overlay.title = "Brightness Down";
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action.spawn = noctalia "brightness-up";
          hotkey-overlay.title = "Brightness Up";
          allow-when-locked = true;
        };
        "XF86AudioRaiseVolume" = {
          action.spawn = noctalia "volume-up";
          hotkey-overlay.title = "Volume Up";
        };
        "XF86AudioLowerVolume" = {
          action.spawn = noctalia "volume-down";
          hotkey-overlay.title = "Volume Down";
        };
      };
  };
}
