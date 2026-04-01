{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # keep-sorted start
      corefonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # keep-sorted end
    ];
  };
}
