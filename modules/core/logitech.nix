{
  lib,
  pkgs,
  ...
}:

{
  # Add a `udev` rule to restart `logiops` when the mouse is connected
  # https://github.com/PixlOne/logiops/issues/239#issuecomment-1044122412
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{manufacturer}=="Logitech", ATTRS{model_name}=="MX Anywhere 3S", RUN{program}="${lib.getExe' pkgs.systemd "systemctl"} --no-block try-restart logid.service"
  '';
  services.udev.packages = [ pkgs.logitech-udev-rules ];
  hardware.uinput.enable = true;
  environment.etc."logid.cfg".source = (pkgs.formats.libconfig { }).generate "logid.cfg" {
    devices = [
      {
        name = "MX Anywhere 3S";

        smartshift = {
          on = true;
          threshold = 15;
          torque = 90;
        };

        hiresscroll = {
          hires = true;
          invert = false;
          target = false;
          /*
            up = {
              mode = "Axis";
              axis = "REL_WHEEL";
              axis_multiplier = 1.0;
            };

            down = {
              mode = "Axis";
              axis = "REL_WHEEL";
              axis_multiplier = -1.0;
            };
          */
        };

        dpi = 1200;

        buttons = [
          {
            cid = 82; # Middle Mouse Button
            action = {
              type = "Keypress";
              keys = [ "BTN_FORWARD" ];
            };
          }
          {
            cid = 86; # Forward Button
            action = {
              type = "Keypress";
              keys = [ "BTN_MIDDLE" ];
            };
          }
        ];
      }
    ];
  };

  environment.systemPackages = [ pkgs.logiops ];
  systemd.services.logid = {
    description = "Logitech Configuration Daemon";
    startLimitIntervalSec = 0;
    after = [ "multi-user.target" ];
    wantedBy = [ "graphical.target" ];
    wants = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.logiops;
      User = "root";
    };
  };
}
