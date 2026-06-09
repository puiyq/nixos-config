{ username, ... }:
{
  programs.nh = {
    enable = true;
    flake = "/home/${username}/nixos-config";
  };
}
