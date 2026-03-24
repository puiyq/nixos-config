{
  /*
    specialisation = {
      etc-overlay.configuration = {
        boot.initrd.systemd.emergencyAccess = true;
        system = {
          etc.overlay = {
            enable = true;
            mutable = true;
          };
          nixos-init.enable = true;
        };
      };
    };
  */

  environment.defaultPackages = [ ];

  system = {
    etc.overlay = {
      enable = true;
      mutable = true;
    };
    nixos-init.enable = true;
    tools = {
      nixos-generate-config.enable = false;
      nixos-option.enable = false;
      nixos-version.enable = false;
      nixos-install.enable = false;
      nixos-enter.enable = false;
    };
    stateVersion = "25.11"; # Do not change! Unless you read all the section of the release notes.
  };

  services = {
    userborn.enable = true;
    dbus.implementation = "broker";
    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandleLidSwitch = "ignore";
    };
  };

  systemd = {
    oomd.enable = false;
    coredump.extraConfig = ''
      Storage=journal
    '';
  };
}
