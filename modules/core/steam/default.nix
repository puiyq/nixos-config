{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./settings.nix
    inputs.steam-config-nix.nixosModules.default
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      protontricks.enable = true;
    };

    gamemode = {
      enable = true;
      settings = {
        custom =
          let
            systemctl = lib.getExe' pkgs.systemd "systemctl";
          in
          {
            start = "${pkgs.writeShellScript "gamemode-start" ''
              ${systemctl} stop beesd@root.service
              ${systemctl} --user stop mpvpaper
            ''}";

            end = "${pkgs.writeShellScript "gamemode-end" ''
              ${systemctl} start beesd@root.service
              ${systemctl} --user start mpvpaper
            ''}";
          };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "high";
        };
      };
    };
  };
}
