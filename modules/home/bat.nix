{
  pkgs,
  lib,
  ...
}:
{
  programs.bat = {
    enable = true;
    config = {
      # bat --list-themes
      theme = lib.mkForce "Dracula";
    };
    extraPackages = with pkgs.bat-extras; [ batman ];
  };
}
