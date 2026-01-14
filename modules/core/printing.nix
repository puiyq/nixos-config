{
  services = {
    printing = {
      enable = false;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    avahi = {
      enable = false;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = false;
  };
}
