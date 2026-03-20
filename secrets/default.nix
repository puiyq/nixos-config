{
  inputs,
  config,
  ...
}:
let
  rootRO = {
    owner = "root";
    group = "root";
    mode = "0400";
  };
  userRO = {
    owner = "kasumi";
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

      "wifi/home-1" = rootRO;
      "wifi/home-2" = rootRO;
      "wifi/phone-hotspot" = rootRO;

      "wifi/eduroam/private-key-password" = rootRO;
      "wifi/eduroam/ca-cert" = {
        format = "binary";
        sopsFile = ./eduroam/ca.pem;
        inherit (rootRO) owner group mode;
      };
      "wifi/eduroam/client-cert" = {
        format = "binary";
        sopsFile = ./eduroam/client-cert.pem;
        inherit (rootRO) owner group mode;
      };
      "wifi/eduroam/private-key" = {
        format = "binary";
        sopsFile = ./eduroam/private-key.pem;
        inherit (rootRO) owner group mode;
      };

      "token/github" = userRO;
      "token/google/calendar_client_id" = userRO;
      "token/google/calendar_client_secret" = userRO;
      "token/wakatime" = userRO;
      "token/wakapi" = userRO;
    };

    templates = {
      "access-tokens" = {
        owner = "kasumi";
        content = ''
          access-tokens = github.com=${config.sops.placeholder."token/github"}
        '';
      };
      "wakatime" = {
        owner = "kasumi";
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
