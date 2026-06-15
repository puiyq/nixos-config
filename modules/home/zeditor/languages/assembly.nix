{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.assembly;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      extensions = [ "assembly" ];
    };
  };
}
