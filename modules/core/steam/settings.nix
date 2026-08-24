{
  pkgs,
  lib,
  host,
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
    config = {
      enable = true;
      onSteamRunning = "close";
      defaultCompatTool = pkgs.dwproton-bin;

      apps = {
        "1512940" = {
          name = "Malody V";
          compatTool = pkgs.dwproton-bin;
          env = {
            PROTON_ENABLE_WAYLAND = true;
            PROTON_USE_WOW64 = true;
          };
        };
        "1091500" = {
          enable = false;
          name = "Cyberpunk 2077";
          compatTool = pkgs.dwproton-bin;
          wrappers = [ (lib.getExe pkgs.gamemode) ];
          env = {
            PROTON_ENABLE_WAYLAND = true;
            PROTON_USE_WOW64 = true;
            PROTON_FSR4_UPGRADE = true;
            PROTON_MLFG_UPGRADE = true;
            DXVK_HDR = true;
          };
          args = [ "--launcher-skip" ];
          dllOverrides = {
            winmm = "n,b";
            version = "n,b";
          };
        };
        "489830" = {
          name = "The Elder Scrolls V: Skyrim Special Edition";
          compatTool = pkgs.dwproton-bin;
          wrappers = [ (lib.getExe pkgs.gamemode) ];
          env = {
            PROTON_ENABLE_WAYLAND = true;
            PROTON_USE_WOW64 = true;
            PROTON_FSR4_UPGRADE = true;
            PROTON_MLFG_UPGRADE = true;
            PROTON_USE_OPTISCALER = true;
            DXVK_HDR = true;
          };
          dllOverrides = {
            winmm = "n,b";
            version = "n,b";
          };
        };
        "1174180" = {
          name = "Red Dead Redemption 2";
          compatTool = pkgs.dwproton-bin;
          wrappers = [ (lib.getExe pkgs.gamemode) ];
          env = {
            # PROTON_ENABLE_WAYLAND = true;
            PROTON_USE_WOW64 = true;
            PROTON_FSR4_UPGRADE = true;
            PROTON_MLFG_UPGRADE = true;
            DXVK_HDR = false;
          };
          args = [
            # "--in-process-gpu"
            # "-skipPatcherCheck"
            # "-useSteam"
            # "-steamAppId=1174180"
            # "-scOfflineOnly"
          ];
          dllOverrides = {
            winmm = "n,b";
            version = "n,b";
          };
        };
      };
      nonSteamApps = lib.mkIf (host == "popipa") {
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
