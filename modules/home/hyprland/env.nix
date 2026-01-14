{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "NIXPKGS_ALLOW_UNFREE, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland, x11"
        "CLUTTER_BACKEND, wayland"
        "QT_QPA_PLATFORM=wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "SDL_VIDEODRIVER, x11"
        "SDL_VIDEO_DRIVER, wayland"
        "MOZ_ENABLE_WAYLAND, 1"
        # Disabling this by default as it can break configurations
        # WIth more than two GPUs.
        # Also added card2 as a further protection should it be enabled
        # This is mostly needed for hybrid laptops
        #"AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1:/dev/card2"
        "GDK_SCALE,1"
        "QT_SCALE_FACTOR,1"
        "EDITOR,nvim"

        "TERMINAL,ghostty"
        "XDG_TERMINAL_EMULATOR,ghostty"
      ];
    };
  };
}
