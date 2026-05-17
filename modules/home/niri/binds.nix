{
  config,
  ...
}:
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    # Applications
    "Mod+Return" = {
      action.spawn = "footclient";
      hotkey-overlay.title = "Terminal";
    };
    "Mod+W" = {
      action.spawn = "vivaldi";
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

    # Window Management
    "Print".action.screenshot = {
      show-pointer = false;
    };
    "Mod+Q".action = close-window;
    "Mod+F".action = fullscreen-window;
    "Mod+Shift+F".action = toggle-window-floating;
    "Mod+Shift+O" = {
      action = toggle-overview;
      hotkey-overlay.title = "Toggle Overview";
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
    "Mod+WheelScrollDown" = {
      action = focus-workspace-down;
      hotkey-overlay.title = "Focus Workspace Down";
    };
    "Mod+WheelScrollUp" = {
      action = focus-workspace-up;
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
    "Mod+Shift+WheelScrollDown" = {
      action = move-window-to-workspace-down;
      hotkey-overlay.title = "Move Window Down Or To Workspace Down";
    };
    "Mod+Shift+WheelScrollUp" = {
      action = move-window-to-workspace-up;
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
  };
}
