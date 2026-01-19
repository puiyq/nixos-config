{
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    image = ../../assets/images/wallpapers/AnimeGirlNightSky.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    polarity = "dark";
    targets.limine.colors.enable = false;
    opacity = {
      terminal = 0.85;
      popups = 0.85;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      emoji = {
        package = pkgs.noto-fonts-monochrome-emoji;
        name = "Noto Monochrome Emoji";
      };
      sizes = {
        applications = 14;
        terminal = 14;
        desktop = 14;
        popups = 14;
      };
    };
  };
}
