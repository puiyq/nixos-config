{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.r;
  R = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      languageserver
      lintr
      styler
    ];
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      extraPackages = with pkgs; [
        air-formatter
        R
      ];

      extensions = [
        "r"
        "air"
      ];

      userSettings = {
        lsp.r_language_server.binary = {
          path = lib.getExe R;
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
