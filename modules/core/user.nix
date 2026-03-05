{
  pkgs,
  host,
  inputs,
  system,
  config,
  username,
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
    root.hashedPasswordFile = config.sops.secrets."popipa/rootPassword".path;
    ${username} = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets."popipa/userPassword".path;
      extraGroups = [
        "adbusers"
        "libvirtd"
        "networkmanager"
        "gamemode"
        "wheel"
        "render"
        "video"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };

  # Userborn currently doesn't automatically allocate subuid/subgid for users
  # and groups. See <https://github.com/nikstur/userborn/issues/7>. So we
  # generate a list.
  environment.etc =
    let
      subuids = pkgs.runCommand "subuid-allocation" { } ''
        root_start=1000000
        root_count=1000000000
        normal_start=$((root_start + root_count))
        normal_count=65536
        max_normal_uid=9999

        echo "0:$root_start:$root_count" > $out

        uid=1000
        while [ "$uid" -le $max_normal_uid ]; do
          echo "$uid:$normal_start:$normal_count" >> $out
          uid=$((uid + 1))
          normal_start=$((normal_start + normal_count))
        done
      '';
    in
    {
      "subuid" = {
        source = subuids;
        mode = "0444";
      };
      "subgid" = {
        source = subuids;
        mode = "0444";
      };
    };
}
