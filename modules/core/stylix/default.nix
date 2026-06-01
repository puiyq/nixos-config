{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    image = ../../../assets/images/wallpapers/Win11Girl.png;
    base16Scheme = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/tinted-theming/schemes/refs/heads/spec-0.11/base16/catppuccin-mocha.yaml";
      sha256 = "sha256-+/adkhwuW/3jCJ3/EWxyz99u13yuTk9Fqqy0YZ4KPPY=";
    };
    polarity = "dark";
    targets.limine.colors.enable = false;
    targets.gtksourceview.enable = false;
    overlays.enable = false;
    opacity.popups = 0.85;
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
