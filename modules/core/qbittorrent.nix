{
  pkgs,
  config,
  username,
  ...
}:

let
  downloadDir = "${config.services.qbittorrent.profileDir}/qBittorrent/downloads";
  mountPoint = "/home/${username}/Downloads/qBittorrent";
  qbittorrentUser = config.services.qbittorrent.user;
  qbittorrentGroup = config.services.qbittorrent.group;
in
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

  systemd.tmpfiles.settings."qbittorrent-downloads" = {
    "${downloadDir}"."d" = {
      mode = "755";
      user = qbittorrentUser;
      group = qbittorrentGroup;
    };
    "/home/${username}/Downloads"."d" = {
      mode = "755";
      user = username;
      group = "users";
    };
    "${mountPoint}"."d" = {
      mode = "755";
      user = username;
      group = "users";
    };
  };

  systemd.mounts = [
    {
      what = downloadDir;
      where = mountPoint;
      type = "none";
      options = "bind,rw";
      wantedBy = [ "multi-user.target" ];
    }
  ];
}
