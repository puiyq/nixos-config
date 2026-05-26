{
  wayland.windowManager.niri.settings = {
    input = {
      keyboard = {
        xkb.layout = "us";
        repeat-delay = 300;
        repeat-rate = 50;
      };
      touchpad = {
        tap = [ ];
        dwt = [ ]; # Disable-while-typing
        natural-scroll = [ ];
        scroll-factor = 0.8;
      };
      focus-follows-mouse = {
        _props.max-scroll-amount = "0%";
      };
    };

    output = [
      {
        _args = [ "eDP-1" ];
        scale = 1.5;
        mode = "1920x1200@60";
        position._props = {
          x = 0;
          y = 0;
        };
      }
    ];

    layout = {
      gaps = 8;
      border.off = [ ];
      focus-ring.off = [ ];
      center-focused-column = "never";
      always-center-single-column = true;
      background-color = "transparent";
      default-column-width.proportion = 1.0;
      preset-column-widths._children = [
        { proportion = 1.0 / 3.0; }
        { proportion = 0.5; }
        { proportion = 2.0 / 3.0; }
        { proportion = 1.0; }
      ];
    };

    gestures.hot-corners.off = [ ];

    clipboard.disable-primary = true;
    prefer-no-csd = true;
    screenshot-path = "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H-%M-%S.png";

    hotkey-overlay = {
      skip-at-startup = true;
      hide-not-bound = true;
    };

    overview.workspace-shadow.off = [ ];

    animations = {
      window-open = {
        duration-ms = 150;
        curve = "ease-out-quad";
      };

      window-close = {
        duration-ms = 150;
        curve = "ease-out-quad";
      };

      window-movement = {
        duration-ms = 200;
        curve = "ease-out-cubic";
      };

      workspace-switch.spring._props = {
        damping-ratio = 0.8;
        stiffness = 1000;
        epsilon = 0.0001;
      };
    };
  };
}
