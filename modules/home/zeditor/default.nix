{
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./languages ];

  programs.zed-editor = {
    enable = true;

    languages = {
      assembly.enable = false;
      nix.enable = true;
      typst.enable = false;
      r.enable = true;
    };

    extensions = [
      "catppuccin-blur"
      "catppuccin-icons"
      "kdl"
    ];

    mutableUserSettings = false;
    userSettings = {
      base_keymap = "VSCode";
      theme = lib.mkForce "Catppuccin Mocha (Blur) [Heavy]";
      icon_theme = "Catppuccin Mocha";
      inlay_hints = {
        enabled = true;
        show_background = true;
      };

      vim_mode = true;
      window_decorations = "server";
      journal.hour_format = "hour24";
      buffer_line_height = "comfortable";
      load_direnv = "direct";
      auto_update = false;

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };
    };
  };
}
