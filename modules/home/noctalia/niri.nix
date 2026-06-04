{ lib, ... }:
{
  wayland.windowManager.niri.settings = {
    layer-rule = [
      {
        match = [ { _props.namespace = "^mpvpaper$"; } ];
        place-within-backdrop = true;
      }
      {
        match = [ { _props.namespace = "^noctalia-wallpaper$"; } ];
        opacity = 0.0;
      }
      {
        match = [ { _props.namespace = "^noctalia-(bar-.*|notification|dock|panel)$"; } ];
        background-effect = {
          xray = false;
          blur = false;
        };
      }
    ];

    window-rule = [
      {
        match = [ { _props.app-id = "dev.noctalia.Noctalia.Settings"; } ];
        open-floating = true;
        default-column-width.fixed = 1080;
        default-window-height.fixed = 740;
      }
    ];

    debug.honor-xdg-activation-with-invalid-serial = [ ];

    switch-events = {
      lid-close.spawn = [
        "noctalia"
        "msg"
        "session"
        "lock-and-suspend"
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
          spawn = noctalia "panel-toggle launcher";
          _props.repeat = false;
        };

        "Mod+V" = {
          spawn = noctalia "panel-toggle clipboard";
          _props.repeat = false;
        };

        # Media Keys
        "XF86AudioMute" = {
          spawn = noctalia "volume-mute";
          _props.repeat = false;
        };
        "XF86AudioMicMute" = {
          spawn = noctalia "mic-mute";
          _props.repeat = false;
        };
        "XF86MonBrightnessDown" = {
          spawn = noctalia "brightness-down";
          _props.allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          spawn = noctalia "brightness-up";
          _props.allow-when-locked = true;
        };
        "XF86AudioRaiseVolume".spawn = noctalia "volume-up";
        "XF86AudioLowerVolume".spawn = noctalia "volume-down";
      };
  };
}
