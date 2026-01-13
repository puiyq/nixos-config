{
  pkgs,
  username,
  host,
  profile,
  flake_dir,
  inputs,
  system,
  config,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    sharedModules = [ inputs.nvf.homeManagerModules.default ];
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    overwriteBackup = true;
    extraSpecialArgs = {
      inherit
        username
        host
        profile
        flake_dir
        inputs
        system
        ;
    };
    users.${username} = {
      imports = [ ./../home ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
      };
    };
  };
  users.mutableUsers = false;
  users.users = {
    root.hashedPasswordFile = config.sops.secrets."nixos/root_password".path;
    ${username} = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets."nixos/user_password".path;
      extraGroups = [
        "adbusers"
        "libvirtd"
        "networkmanager"
        "wheel"
        "render"
        "video"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };
  nix = {
    settings = {
      cores = 8;
      max-jobs = 2;
      allowed-users = [ "${username}" ];
      system-features = [
        "gccarch-znver4"
        "uid-range"
      ];
    };
    extraOptions = ''
      !include ${config.sops.templates."access-tokens".path}
    '';
  };
}
