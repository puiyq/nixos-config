{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      theme = [ "Dracula" ];
      font-size = 12;
      adjust-cell-height = "10%";
      window-theme = "dark";
      window-height = 32;
      window-width = 110;
      background-opacity = 0.95;
      background-blur = 60;
      cursor-style = "bar";
      mouse-hide-while-typing = true;
      #copy-on-select = "clipboard";
      font-family = [ "JetBrainsMono Nerd Font" ];
      title = "GhosTTY";
      wait-after-command = false;
      confirm-close-surface = false;
      shell-integration = "detect";
      window-save-state = "always";
      gtk-single-instance = true;
      unfocused-split-opacity = 0.5;
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";
      shell-integration-features = "cursor,sudo,ssh-env,ssh-terminfo";
      selection-background = [ "44475a" ];
      selection-foreground = [ "f8f8f2" ];
    };
  };
}
