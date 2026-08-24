{
  inputs,
  pkgs,
  lib,
  host,
  ...
}:
{
  imports = [
    ./settings.nix
    inputs.steam-config-nix.nixosModules.default
  ];

  hardware.graphics = {
    enable32Bit = lib.mkOverride 0 (host != "roselia");
    package32 = lib.mkIf (host == "roselia") (lib.mkOverride 0 pkgs.emptyFile);
  };
  services.pipewire.alsa.support32Bit = lib.mkForce (host != "roselia");

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
