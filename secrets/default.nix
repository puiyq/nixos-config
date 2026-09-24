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

  dynamicSecrets =
    tokenNames
    |> map (n: {
      name = "token/${n}";
      value = userRO;
    })
    |> builtins.listToAttrs;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./hosts/popipa.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/keys.txt";
    };

    secrets = {
      "popipa/root_password".neededForUsers = true;
      "popipa/user_password".neededForUsers = true;
      "roselia/root_password".neededForUsers = true;
      "roselia/user_password".neededForUsers = true;
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
