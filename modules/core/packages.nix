{
  pkgs,
  ...
}:
{
  programs = {
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
      useNautilus = true;
    };
    seahorse.enable = true;
    hyprland.enable = false;
    hyprlock.enable = false;
    fuse.userAllowOther = true;
    trippy.enable = false;
  };
  nixpkgs.config.allowUnfree = true;
}
