{
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
      extensions = [ "typst" ];
      userSettings.languages.Typst.language_servers = [ "tinymist" ];
    };
  };
}
