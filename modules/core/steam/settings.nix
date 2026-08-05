{
  pkgs,
  lib,
  username,
  ...
}:
{
  programs.steam = {
    package = pkgs.steam.override {
      extraProfile = ''
        export PROTON_USE_NTSYNC=1
        export PROTON_DXVK_LOWLATENCY=1
      '';
    };
    config =
      let
        niri = lib.getExe pkgs.niri;
      in
      {
        enable = true;
        onSteamRunning = "close";
        defaultCompatTool = pkgs.dwproton-bin;

        apps = {
          "Malody V" = {
            id = 1512940;
            compatTool = pkgs.dwproton-bin;
            preHook = ''
              ${niri} msg output DP-1 mode 2560x1440@199.997
              ${niri} msg output DP-1 vrr no
            '';
            env = {
              PROTON_ENABLE_WAYLAND = true;
              PROTON_USE_WOW64 = true;
            };
          };
          "Cyberpunk 2077" = {
            id = 1091500;
            compatTool = pkgs.dwproton-bin;
            preHook = ''
              ${niri} msg output DP-1 mode 2560x1440@119.998
              ${niri} msg output DP-1 vrr yes
            '';
            wrappers = [ (lib.getExe pkgs.gamemode) ];
            env = {
              WINEDLLOVERRIDES = "winmm,version=n,b";
              PROTON_ENABLE_WAYLAND = true;
              PROTON_USE_WOW64 = true;
              PROTON_FSR4_UPGRADE = true;
              PROTON_MLFG_UPGRADE = true;
              DXVK_HDR = true;
            };
            args = [ "--launcher-skip" ];
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
