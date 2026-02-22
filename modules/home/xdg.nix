{ pkgs, ... }:
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps.enable = true;
    # workaround of https://github.com/NixOS/nixpkgs/pull/271037
    systemDirs.data = [ "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}" ];
  };
}
