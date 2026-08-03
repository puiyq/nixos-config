{ pkgs, username, ... }:
{
  programs.steam = {
    package = pkgs.steam.override {
      extraProfile = ''
        export PROTON_USE_NTSYNC=1
        export PROTON_DXVK_LOWLATENCY=1
      '';
    };
    config = {
      enable = true;
      onSteamRunning = "close";
      defaultCompatTool = pkgs.dwproton-bin;

      apps = {
        "Malody V" = {
          id = 1512940;
          compatTool = pkgs.dwproton-bin;
          launchOptions = {
            env = {
              PROTON_ENABLE_WAYLAND = true;
              PROTON_USE_WOW64 = true;
            };
          };
        };
      };
      nonSteamApps = {
        "White Album 2" = {
          id = 2889710772;
          allowOverlay = false;
          compatTool = pkgs.dwproton-bin;
          target = "/home/${username}/Documents/White Album 2/WA2_chs.exe";
        };
      };
    };
  };
}
