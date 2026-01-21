{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
    };

    secrets = {
      "nixos/root_password".neededForUsers = true;
      "nixos/user_password".neededForUsers = true;

      "token/github" = {
        mode = "0400";
        owner = "puiyq";
        group = "users";
      };
    };

    templates."access-tokens" = {
      owner = "puiyq";
      content = ''
        access-tokens = github.com=${config.sops.placeholder."token/github"}
      '';
    };
  };
}
