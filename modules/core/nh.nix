{ username, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--optimise";
    };
    flake = "/home/${username}/nixos-config";
  };
}
