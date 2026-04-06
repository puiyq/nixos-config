{
  host,
  ...
}:
{
  networking = {
    hostName = host;

    useDHCP = false;
    useNetworkd = true;
    modemmanager.enable = false;
    wireless.iwd = {
      enable = true;
      settings = {
        General.EnableNetworkConfiguration = false;
        Network.EnableIPv6 = true;
        Settings.AutoConnect = true;
      };
    };

    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  systemd.network.networks."40-wlan0" = {
    networkConfig = {
      IgnoreCarrierLoss = "3s";
    };
  };

  services = {
    resolved.enable = true;
    ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = true;
    };
    openssh = {
      generateHostKeys = true; # generate hostkey without ssh daemon
      hostKeys = [
        {
          type = "ed25519";
          path = "/etc/ssh/ssh_host_ed25519_key";
        }
      ];
    };
  };
}
