{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      #gamescopeSession.enable = true;
      protontricks.enable = false;
      extraCompatPackages = [
        pkgs.proton-cachyos_x86_64_v3
      ];
    };

    #gamescope = {
    #enable = true;
    # capSysNice = true;
    #args = [
    #   "--rt"
    #   "--expose-wayland"
    # ];
    #};

    gamemode = {
      enable = true;
      settings.gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1;
        amd_performance_level = "high";
      };
    };
  };
}
