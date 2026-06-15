{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.json;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor.userSettings.languages.JSON.language_servers = [ "!package-version-server" ];
  };
}
