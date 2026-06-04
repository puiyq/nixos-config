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

    extraPackages = with pkgs; [
      color-lsp
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

      helix_mode = true;
      window_decorations = "server";
      journal.hour_format = "hour24";
      buffer_line_height = "comfortable";
      load_direnv = "direct";
      auto_update = false;

      collaboration_panel.dock = "left";
      project_panel.dock = "left";
      outline_panel.dock = "left";
      git_panel.dock = "left";
      agent = {
        dock = "right";
        sidebar_side = "right";
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };
    };
  };
}
