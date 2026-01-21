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
    fuse.userAllowOther = true;
  };
  nixpkgs.config.allowUnfree = true;
}
