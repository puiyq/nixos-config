{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./popipa.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
    };

    secrets = {
      "popipa/rootPassword".neededForUsers = true;
      "popipa/userPassword".neededForUsers = true;

      "token/github" = {
        mode = "0400";
        owner = "kasumi";
        group = "users";
      };
    };

    templates."access-tokens" = {
      owner = "kasumi";
      content = ''
        access-tokens = github.com=${config.sops.placeholder."token/github"}
      '';
    };
  };
}
