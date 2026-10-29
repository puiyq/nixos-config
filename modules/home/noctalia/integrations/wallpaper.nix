{
  config,
  pkgs,
  lib,
  host,
  ...
}:
let
  wallpapers = {
    popipa = "Win11Girl.mp4";
    roselia = "Win11Girl_4K_60FPS.mp4";
  };
in
{
  home.packages = [ pkgs.gslapper ];

  systemd.user.services.gslapper = {
    Unit = {
      Description = "gSlapper Wallpaper Service";
      Documentation = "https://github.com/Nomadcxx/gSlapper";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
    };
    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.gslapper} --systemd -p -o \"no-audio loop\" '*' ${config.home.homeDirectory}/Videos/Wallpapers/${wallpapers.${host}}";
      ExecReload = "${lib.getExe' pkgs.util-linux "kill"} -HUP $MAINPID";
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };
}
