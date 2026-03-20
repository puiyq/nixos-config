{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.c;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor.userSettings = {
      lsp.clangd.binary.path = lib.getExe' pkgs.clang-tools "clangd";
      languages."C++".format_on_save = "on";
    };
  };
}
