{
  config,
  osConfig,
  ...
}:
{
  accounts.calendar = {
    basePath = "${config.xdg.dataHome}/calendars";

    accounts.personal = {
      remote.type = "google_calendar";
      local = {
        type = "filesystem";
        fileExt = ".ics";
      };
      khal = {
        enable = true;
        type = "discover";
      };

      vdirsyncer = {
        enable = true;
        metadata = [
          "color"
          "displayname"
        ];
        collections = [ "puiyongqing@gmail.com" ];
        conflictResolution = "remote wins";
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
          start = "datetime.now() - timedelta(days=365)";
          end = "datetime.now() + timedelta(days=365)";
        };
      };
    };
  };

  services.vdirsyncer.enable = true;
  programs.vdirsyncer = {
    enable = true;
    statusPath = "${config.xdg.dataHome}/vdirsyncer/status";
  };

  programs.khal = {
    enable = true;
    settings.default.default_calendar = "puiyongqing@gmail.com";
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
  };
}
