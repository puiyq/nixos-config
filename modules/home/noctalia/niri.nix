{ host, lib, ... }:
let
  windowSizes = {
    popipa = {
      width = 1080;
      height = 740;
    };

    roselia = {
      width = 1440;
      height = 960;
    };
  };

  windowSize = windowSizes.${host};
in
{
  wayland.windowManager.niri.settings = {
    _children = [
      {
        layer-rule._children = [
          { match._props.namespace = "^mpvpaper$"; }
          { place-within-backdrop = true; }
        ];
      }
      {
        layer-rule._children = [
          { match._props.namespace = "^noctalia-wallpaper$"; }
          { opacity = 0.0; }
        ];
      }
      {
        layer-rule._children = [
          { match._props.namespace = "^noctalia-bar-.*$"; }
          { background-effect.blur = false; }
        ];
      }
      {
        layer-rule._children = [
          { match._props.namespace = "^noctalia-panel$"; }
          { background-effect.xray = false; }
        ];
      }
      {
        window-rule._children = [
          { match._props.app-id = "dev.noctalia.Noctalia"; }
          { open-floating = true; }
          { opacity = 0.9; }
          {
            background-effect = {
              blur = true;
              xray = false;
            };
          }
          { default-column-width.fixed = windowSize.width; }
          { default-window-height.fixed = windowSize.height; }
        ];
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
