{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.python;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      userSettings = {
        lsp = {
          ruff = {
            binary = {
              arguments = [ "server" ];
            };
            initialization_options.settings = {
              "lineLength" = 80;
              lint.extendSelect = [ "I" ];
            };
          };
          ty = {
            binary = {
              arguments = [ "server" ];
            };
            settings.diagnosticMode = "off";
          };
        };

        languages = {
          Python = {
            code_actions_on_format = {
              "source.organizeImports.ruff" = true;
              "source.fixAll.ruff" = true;
            };
            language_servers = [
              "ruff"
              "ty"
              "!basedpyright"
            ];
          };
        };
      };
    };
  };
}
