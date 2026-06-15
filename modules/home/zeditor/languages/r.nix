{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.r;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      extensions = [
        "r"
        "air"
      ];
      userSettings = {
        lsp.r_language_server.binary = {
          arguments = [
            "--slave"
            "--no-save"
            "--no-restore"
            "-e"
            "languageserver::run()"
          ];
        };
        languages.R = {
          language_servers = [
            "air"
            "r_language_server"
          ];
          use_on_type_format = false;
        };
      };
    };
  };
}
