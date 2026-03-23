{ pkgs, ... }:
{
  gtk = {
    colorScheme = "dark";
    gtk4.theme = null;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
