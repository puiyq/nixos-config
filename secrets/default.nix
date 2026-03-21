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
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./popipa.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
    };

    secrets = {
      "popipa/rootPassword" = {
        neededForUsers = true;
      };
      "popipa/userPassword" = {
        neededForUsers = true;
      };

      "token/github" = userRO;
      "token/google/calendar_client_id" = userRO;
      "token/google/calendar_client_secret" = userRO;
      "token/wakatime" = userRO;
      "token/wakapi" = userRO;
    };

    templates = {
      "access-tokens" = {
        owner = username;
        content = ''
          access-tokens = github.com=${config.sops.placeholder."token/github"}
        '';
      };
      "wakatime" = {
        owner = username;
        content = ''
          [settings]
          api_key = ${config.sops.placeholder."token/wakatime"}
          [api_urls]
          .* = https://wakapi.dev/api|${config.sops.placeholder."token/wakapi"}
          .* = https://api.wakatime.com/api/v1|${config.sops.placeholder."token/wakatime"}
        '';
      };
    };
  };
}
