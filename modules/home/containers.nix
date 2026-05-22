{ osConfig, ... }:
{
  services.podman = {
    enable = true;
    enableTypeChecks = true;
    inherit (osConfig.virtualisation.podman) package;
    containers.matlab-vnc = {
      image = "mathworks/matlab:r2025b";
      autoStart = false;
      ports = [
        "5901:5901"
        "6080:6080"
      ];
      volumes = [ "/home/kasumi/devshell/matlab-work:/home/matlab/work" ];
      userNS = "keep-id";
      extraPodmanArgs = [
        "--shm-size=512M"
        "--tty"
      ];
      exec = "-vnc";
    };
  };
}
