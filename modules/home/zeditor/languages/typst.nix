{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.typst;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      extraPackages = [ pkgs.tinymist ];
      extensions = [ "typst" ];
      userSettings = {
        lsp.tinymist.binary.path = lib.getExe pkgs.tinymist;
        languages.Typst = {
          language_servers = [ "tinymist" ];
        };
      };
    };
  };
}
