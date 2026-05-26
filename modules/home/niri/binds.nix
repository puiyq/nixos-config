{
  wayland.windowManager.niri.settings.binds = {
    # Applications
    "Mod+Return".spawn = "footclient";
    "Mod+W".spawn = "vivaldi";
    "Mod+Y" = {
      spawn = [
        "footclient"
        "-e"
        "yazi"
      ];
      _props.repeat = false;
    };

    # Window Management
    "Print".screenshot._props.show-pointer = false;
    "Mod+Q".close-window = [ ];
    "Mod+F".fullscreen-window = [ ];
    "Mod+Shift+F".toggle-window-floating = [ ];
    "Mod+Shift+O" = {
      toggle-overview = [ ];
      _props.repeat = false;
    };

    # Navigation (Vim+Arrows)
    "Mod+H".focus-column-left = [ ];
    "Mod+L".focus-column-right = [ ];
    "Mod+J".focus-window-or-workspace-down = [ ];
    "Mod+K".focus-window-or-workspace-up = [ ];
    "Mod+Left".focus-column-left = [ ];
    "Mod+Right".focus-column-right = [ ];
    "Mod+Down".focus-window-or-workspace-down = [ ];
    "Mod+Up".focus-window-or-workspace-up = [ ];
    "Mod+WheelScrollDown".focus-workspace-down = [ ];
    "Mod+WheelScrollUp".focus-workspace-up = [ ];

    # Movement (Vim+Arrows)
    "Mod+Shift+H".move-column-left = [ ];
    "Mod+Shift+L".move-column-right = [ ];
    "Mod+Shift+J".move-window-down-or-to-workspace-down = [ ];
    "Mod+Shift+K".move-window-up-or-to-workspace-up = [ ];
    "Mod+Shift+Left".move-column-left = [ ];
    "Mod+Shift+Right".move-column-right = [ ];
    "Mod+Shift+Down".move-window-down-or-to-workspace-down = [ ];
    "Mod+Shift+Up".move-window-up-or-to-workspace-up = [ ];
    "Mod+Shift+WheelScrollDown".move-window-to-workspace-down = [ ];
    "Mod+Shift+WheelScrollUp".move-window-to-workspace-up = [ ];

    "Mod+BracketLeft".consume-or-expel-window-left = [ ];
    "Mod+BracketRight".consume-or-expel-window-right = [ ];
    "Mod+Comma".consume-window-into-column = [ ];
    "Mod+Period".expel-window-from-column = [ ];

    # Resizing (Vim+Arrows)
    "Mod+Ctrl+H".set-column-width = "-10%";
    "Mod+Ctrl+L".set-column-width = "+10%";
    "Mod+Ctrl+J".set-window-height = "-10%";
    "Mod+Ctrl+K".set-window-height = "+10%";
    "Mod+Ctrl+Left".set-column-width = "-10%";
    "Mod+Ctrl+Right".set-column-width = "+10%";
    "Mod+Ctrl+Up".set-window-height = "-10%";
    "Mod+Ctrl+Down".set-window-height = "+10%";

    "Mod+M".maximize-column = [ ];
    "Mod+Space".switch-preset-column-width = [ ];
    "Mod+Shift+Space".switch-preset-window-height = [ ];
  };
}
