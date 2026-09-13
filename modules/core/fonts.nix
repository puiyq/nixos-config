{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      # keep-sorted start
      corefonts
      dejavu_fonts
      liberation_ttf
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      # keep-sorted end
    ];
  };
}
