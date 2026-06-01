{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.mpvpaper.enable = true;
  systemd.user.services.mpvpaper = {
    Unit = {
      Description = "Video wallpaper for wayland desktops";
      Documentation = "https://github.com/GhostNaN/mpvpaper";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
    };
    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };
    Service = {
      ExecStart = pkgs.writeShellScript "mpvpaper" ''
        ${lib.getExe pkgs.mpvpaper} -p -o "no-audio loop" ALL ~/Videos/Wallpapers/Win11Girl.mp4
      '';
      # Restart every hour because of memory leak in mpvpaper
      Restart = "always";
      RuntimeMaxSec = "1h";
    };
  };
}
