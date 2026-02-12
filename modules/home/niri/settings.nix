{
  lib,
  pkgs,
  ...
}:
{
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
  };
}
