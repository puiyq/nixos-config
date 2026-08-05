{
  host,
  lib,
  ...
}:
{
  networking = {
    hostName = host;

    useDHCP = false;
    useNetworkd = true;
    modemmanager.enable = false;
    wireless.iwd = lib.mkIf (host == "popipa") {
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

  boot.initrd.systemd.network.wait-online.enable = false;
  systemd.network = {
    wait-online.enable = false;
    networks."40-wlan0" = lib.mkIf (host == "popipa") {
      networkConfig = {
        IgnoreCarrierLoss = "3s";
      };
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
