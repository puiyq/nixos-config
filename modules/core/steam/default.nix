{ pkgs, ... }:
{
  imports = [ ./proton.nix ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      protontricks.enable = true;
      proton = {
        enable = true;
        packages = [
          {
            package = pkgs.dwproton-bin;
            settings = {
              PROTON_USE_NTSYNC = "1";
              PROTON_DXVK_LOWLATENCY = "1";
            };
          }
        ];
      };
    };

    gamemode = {
      enable = true;
      enableRenice = true;
      settings.gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1;
        amd_performance_level = "high";
      };
    };
  };
}
