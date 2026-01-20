{ pkgs, ... }:
{
  programs = {
    thunar = {
      enable = false;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
