{
  host,
  options,
  lib,
  ...
}:
{
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

}
