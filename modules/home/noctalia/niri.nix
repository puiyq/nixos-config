{ lib, ... }:
{
  programs.niri.settings = {
    spawn-at-startup = [ { command = [ "noctalia-shell" ]; } ];

    layer-rules = [
      {
        matches = [ { namespace = "linux-wallpaperengine"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "^noctalia-wallpaper.*"; } ];
        opacity = 0.0;
      }
    ];

    debug.honor-xdg-activation-with-invalid-serial = [ ];

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
      {
        "Mod+Shift+Return" = {
          action.spawn = noctalia "launcher toggle";
          hotkey-overlay.title = "Launcher";
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
      };
  };
}
