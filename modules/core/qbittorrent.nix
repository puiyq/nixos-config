{
  pkgs,
  config,
  username,
  ...
}:

{
  services.qbittorrent = {
    enable = true;
    package = pkgs.qbittorrent-enhanced-nox;
    torrentingPort = 57231;
    serverConfig = {
      LegalNotice.Accepted = true;
      Network.PortForwardingEnabled = false;
      RSS.Session.EnableProcessing = true;
      BitTorrent.Session = {
        IgnoreSlowTorrentsForQueueing = true;
        AddTrackersFromURLEnabled = true;
        AdditionalTrackersURL = "https://ngosang.github.io/trackerslist/trackers_all.txt";
      };
      Preferences = {
        General.Locale = "zh_CN";
        WebUI = {
          Enabled = true;
          Address = "127.0.0.1";
          LocalHostAuth = false;
        };
      };
    };
  };

  systemd.mounts = [
    {
      what = "${config.services.qbittorrent.profileDir}/qBittorrent/downloads";
      where = "/home/${username}/Downloads/qBittorrent";
      type = "none";
      options = "bind,rw";
      wantedBy = [ "multi-user.target" ];
    }
  ];
}
