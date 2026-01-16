{
  programs.trippy = {
    enable = false;
    settings = {
      tui = {
        geoip-mmdb-file = "/var/lib/GeoIP/GeoLite2-City.mmdb";
        tui-geoip-mode = "long";
        tui-locale = "zh";
        tui-timezone = "Asia/Kuala_Lumpur";
      };
    };
  };
}
