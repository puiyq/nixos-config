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

    Install.WantedBy = [ config.wayland.systemd.target ];

    Service = {
      Type = "notify";
      ExecStart = "${lib.getExe pkgs.gslapper} --systemd -r 60 -o \"no-audio loop\" '*' ${config.home.homeDirectory}/Videos/Wallpapers/${wallpapers.${host}}";
      ExecReload = "${lib.getExe' pkgs.util-linux "kill"} -HUP $MAINPID";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 30;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };
}
