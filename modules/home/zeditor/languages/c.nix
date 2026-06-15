{
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
      languages."C++".format_on_save = "on";
    };
  };
}
