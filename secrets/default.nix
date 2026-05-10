{
  inputs,
  config,
  username,
  ...
}:
let
  userRO = {
    owner = username;
    group = "users";
    mode = "0400";
  };

  tokenNames = [ "github" ];

  dynamicSecrets = builtins.listToAttrs (
    map (n: {
      name = "token/${n}";
      value = userRO;
    }) tokenNames
  );
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./hosts/popipa.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
    };

    secrets = {
      "popipa/root_password".neededForUsers = true;
      "popipa/user_password".neededForUsers = true;
    }
    // dynamicSecrets;

    templates = {
      "access-tokens" = {
        owner = username;
        content = ''
          access-tokens = github.com=${config.sops.placeholder."token/github"}
        '';
      };
    };
  };
}
