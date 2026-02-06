{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];
  systemd.user.services.niri-flake-polkit.enable = false;
  programs = {
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    seahorse.enable = true;
    hyprland.enable = false;
    fuse.userAllowOther = true;
  };
  nixpkgs.config.allowUnfree = true;
}
