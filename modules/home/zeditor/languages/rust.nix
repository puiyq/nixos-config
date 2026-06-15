{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.rust;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {

      userSettings = {
        lsp = {
          rust-analyzer = {
            enable_lsp_tasks = true;
            initialization_options = {
              cargo.all_Features = true;
              check.command = "clippy";
              procMacro.enable = true;
            };
          };
        };

        languages = {
          Rust = {
            language_servers = [ "rust-analyzer" ];
          };
        };
      };
    };
  };
}
