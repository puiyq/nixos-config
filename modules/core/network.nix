{
  host,
  options,
  ...
}:
{
  networking = {
    hostName = "${host}";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
