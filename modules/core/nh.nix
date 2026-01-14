{ host, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--optimise";
    };
    flake = "/home/${host}/nixos-config";
  };
}
