{
  pkgs,
  lib,
  ...
}:
{
  programs.zed-editor.userSettings = {
    languages."*".language_server = [ "wakatime" ];
    lsp.wakatime.binary = {
      path = lib.getExe pkgs.wakatime-ls;
      arguments = [
        "--wakatime-cli"
        "${lib.getExe pkgs.wakatime-cli}"
      ];
    };
  };
}
