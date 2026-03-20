{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];
  systemd.user.services.niri-flake-polkit.enable = false;

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    gpu-screen-recorder.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
  };
  nixpkgs.config.allowUnfree = true;
}
