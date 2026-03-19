{
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./languages ];

  programs.zed-editor = {
    languages = {
      assembly.enable = true;
      nix.enable = true;
      typst.enable = true;
      r.enable = true;
    };
    enable = true;
    extensions = [
      "catppuccin-blur"
      "catppuccin-icons"
      "wakatime"
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

      window_decorations = "server";
      edit_predictions.disabled_globs = [ "**/*.age" ];

      vim_mode = true;
      journal.hour_format = "hour24";
      auto_update = false;

      buffer_line_height = "comfortable";

      load_direnv = "direct";

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };
    };
  };
}
