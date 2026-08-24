{
  host,
  inputs,
  system,
  config,
  username,
  publicKey,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    overwriteBackup = true;
    extraSpecialArgs = {
      inherit
        username
        host
        inputs
        system
        publicKey
        ;
    };
    users.${username} = {
      imports = [ ./../home ];
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "26.05";
      };
    };
  };
  users.mutableUsers = false;
  users.groups.fuse = { };
  users.users = {
    root.hashedPasswordFile = config.sops.secrets."popipa/root_password".path;
    ${username} = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets."popipa/user_password".path;
      extraGroups = [
        "adbusers"
        "libvirtd"
        "networkmanager"
        "wireshark"
        "gamemode"
        "wheel"
        "render"
        "video"
        "uinput"
        "input"
        "fuse"
      ];
    };
  };
}
