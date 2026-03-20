{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.json;
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor.extraPackages = [ pkgs.package-version-server ];
  };
}
