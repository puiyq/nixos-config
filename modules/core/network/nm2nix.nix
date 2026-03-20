{ config, ... }:
{
  profiles = {
    "AB9@celcomdigifibre" = {
      connection = {
        id = "AB9@celcomdigifibre";
        interface-name = "wlan0";
        type = "wifi";
        uuid = "2656c6c9-de08-48cc-90e7-42292bd6ef68";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
      proxy = { };
      wifi = {
        mode = "infrastructure";
        ssid = "AB9@celcomdigifibre";
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
      };
    };

    "AB9@celcomdigifibre_5G" = {
      connection = {
        id = "AB9@celcomdigifibre_5G";
        interface-name = "wlan0";
        type = "wifi";
        uuid = "a3b76275-7d84-4bb2-9788-89f3d474301b";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
      proxy = { };
      wifi = {
        mode = "infrastructure";
        ssid = "AB9@celcomdigifibre_5G";
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
      };
    };

    Hotspot = {
      connection = {
        id = "Hotspot";
        interface-name = "wlan0";
        type = "wifi";
        uuid = "fb5f22d5-e802-44f4-a9d8-3c3bb6b7e42a";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
      proxy = { };
      wifi = {
        mode = "infrastructure";
        ssid = "Hotspot";
      };
      wifi-security = {
        key-mgmt = "sae";
      };
    };

    TP-Link_3004 = {
      connection = {
        id = "TP-Link_3004";
        type = "wifi";
        uuid = "d4e5026c-d0e2-4ab0-84c6-0d289d0e20a7";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
      proxy = { };
      wifi = {
        mode = "infrastructure";
        ssid = "TP-Link_3004";
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
      };
    };

    "eduroam (from geteduroam)" = {
      "802-1x" = {
        altsubject-matches = "DNS:radius.geteduroam.my;";
        ca-cert = config.sops.secrets."wifi/eduroam/ca-cert".path;
        client-cert = config.sops.secrets."wifi/eduroam/client-cert".path;
        eap = "tls;";
        identity = "vtuoiiwz2xiit2zi@students.swinburne.edu.my";
        private-key = config.sops.secrets."wifi/eduroam/private-key".path;
      };
      connection = {
        autoconnect-priority = "1";
        id = "eduroam (from geteduroam)";
        permissions = "user:kasumi:;";
        type = "wifi";
        uuid = "6c073bfb-d20a-4dd0-8e72-98324db3505b";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "default";
        method = "auto";
      };
      proxy = { };
      wifi = {
        ssid = "eduroam";
      };
      wifi-security = {
        group = "ccmp;";
        key-mgmt = "wpa-eap";
        pairwise = "ccmp;";
        proto = "rsn;";
      };
    };
  };

  secrets.entries = [
    {
      file = config.sops.secrets."wifi/home-1".path;
      key = "psk";
      matchId = "TP-Link_3004";
      matchType = "wifi";
      matchSetting = "wifi-security";
    }
    {
      file = config.sops.secrets."wifi/home-2".path;
      key = "psk";
      matchId = "AB9@celcomdigifibre";
      matchType = "wifi";
      matchSetting = "wifi-security";
    }
    {
      file = config.sops.secrets."wifi/home-2".path;
      key = "psk";
      matchId = "AB9@celcomdigifibre_5G";
      matchType = "wifi";
      matchSetting = "wifi-security";
    }
    {
      file = config.sops.secrets."wifi/phone-hotspot".path;
      key = "psk";
      matchId = "Hotspot";
      matchType = "wifi";
      matchSetting = "wifi-security";
    }
    {
      file = config.sops.secrets."wifi/eduroam/private-key-password".path;
      key = "private-key-password";
      matchId = "eduroam (from geteduroam)";
      matchType = "wifi";
      matchSetting = "802-1x";
    }
  ];
}
