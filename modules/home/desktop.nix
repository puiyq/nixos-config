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

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    qt5ctSettings.Appearance.icon_theme = "Papirus-Dark";
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;
    };
    mimeApps.enable = true;
    # workaround of https://github.com/NixOS/nixpkgs/pull/271037
    systemDirs.data = [ "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}" ];
  };
}
