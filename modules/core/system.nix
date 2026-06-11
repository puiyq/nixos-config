{
  environment.defaultPackages = [ ];

  system = {
    etc.overlay = {
      enable = true;
      mutable = true;
    };
    nixos-init.enable = true;
    tools = {
      nixos-rebuild.enableRun0Elevation = true;
      nixos-generate-config.enable = false;
      nixos-option.enable = false;
      nixos-version.enable = false;
      nixos-install.enable = false;
      nixos-enter.enable = false;
    };
    stateVersion = "26.05"; # Do not change! Unless you read all the section of the release notes.
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
    coredump.settings.Coredump = {
      Storage = "journal";
    };
  };
}
