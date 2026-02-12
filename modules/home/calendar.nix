{ config, osConfig, ... }:
let
  # Common settings
  commonVdirsyncerSettings = {
    enable = true;
    metadata = [
      "color"
      "displayname"
    ];
    tokenFile = "${config.xdg.dataHome}/vdirsyncer/google_token";
    clientIdCommand = [
      "cat"
      osConfig.sops.secrets."token/google/calendar_client_id".path
    ];
    clientSecretCommand = [
      "cat"
      osConfig.sops.secrets."token/google/calendar_client_secret".path
    ];
    timeRange = {
      start = "datetime.now() - timedelta(days=90)";
      end = "datetime.now() + timedelta(days=365)";
    };
  };

  commonLocalSettings = {
    type = "filesystem";
    fileExt = ".ics";
  };

in
{
  accounts.calendar = {
    basePath = "${config.xdg.dataHome}/calendars";

    accounts = {
      google = {
        remote.type = "google_calendar";
        local = commonLocalSettings;

        khal = {
          enable = true;
          type = "discover";
          readOnly = false;
        };

        vdirsyncer = commonVdirsyncerSettings // {
          collections = [ "puiyongqing@gmail.com" ];
        };
      };

      holidays = {
        remote.type = "google_calendar";
        local = commonLocalSettings;

        khal = {
          enable = true;
          type = "discover";
          readOnly = true;
        };

        vdirsyncer = commonVdirsyncerSettings // {
          collections = [
            "cln2srb1dhgnisr9c4hmgrrcd5i62ua0ctp6utbg5pr2sor1dhimsp31e8n6errfctm6abj3dtmg@virtual"
          ];
          conflictResolution = "remote wins";
        };
      };
    };
  };

  programs.vdirsyncer = {
    enable = true;
    statusPath = "${config.xdg.dataHome}/vdirsyncer/status";
  };

  programs.khal = {
    enable = true;
    locale = {
      dateformat = "%Y-%m-%d";
      timeformat = "%H:%M";
      datetimeformat = "%Y-%m-%d %H:%M";
      longdateformat = "%Y-%m-%d";
      longdatetimeformat = "%Y-%m-%d %H:%M";
      default_timezone = "Asia/Kuching";
      local_timezone = "Asia/Kuching";
      firstweekday = 0;
      weeknumbers = "left";
    };
    settings = {
      default = {
        default_calendar = "puiyongqing@gmail.com";
      };
    };
  };

  services.vdirsyncer = {
    enable = true;
    frequency = "hourly";
    verbosity = "CRITICAL";
  };
}
