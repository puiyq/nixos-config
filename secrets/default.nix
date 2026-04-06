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

  wifiFile = ./networks/wifi.yaml;

  certNames = [
    "ca_cert"
    "client_cert"
    "private_key"
  ];
  wifiNetworks = {
    eduroam = [
      "private_key_password"
      "identity"
    ];
  };
  tokenNames = [
    "github"
    "wakatime"
    "wakapi"
    "google_calendar_client_id"
    "google_calendar_client_secret"
  ];

  dynamicSecrets = builtins.listToAttrs (
    (map (n: {
      name = "eduroam/${n}";
      value = {
        sopsFile = ./networks/certs/eduroam/${n}.pem;
        format = "binary";
        restartUnits = [ "iwd.service" ];
      };
    }) certNames)

    ++ (builtins.concatMap (
      net:
      map (key: {
        name = "${net}/${key}";
        value.sopsFile = wifiFile;
      }) wifiNetworks.${net}
    ) (builtins.attrNames wifiNetworks))

    ++ (map (n: {
      name = "token/${n}";
      value = userRO;
    }) tokenNames)
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
      "wakatime" = {
        path = "/home/${username}/.wakatime.cfg";
        owner = username;
        content = ''
          [settings]
          api_key = ${config.sops.placeholder."token/wakatime"}
          [api_urls]
          .* = https://wakapi.dev/api|${config.sops.placeholder."token/wakapi"}
          .* = https://api.wakatime.com/api/v1|${config.sops.placeholder."token/wakatime"}
        '';
      };
      "eduroam.8021x" = {
        path = "/var/lib/iwd/eduroam.8021x";
        mode = "0600";
        owner = "root";
        restartUnits = [ "iwd.service" ];
        content = ''
          [Security]
          EAP-Method=TLS
          EAP-Identity=${config.sops.placeholder."eduroam/identity"}
          EAP-TLS-CACert=embed:ca_cert
          EAP-TLS-ClientCert=embed:client_cert
          EAP-TLS-ClientKey=embed:client_key
          EAP-TLS-ClientKeyPassphrase=${config.sops.placeholder."eduroam/private_key_password"}
          EAP-TLS-ServerDomainMask=radius.geteduroam.my

          [Settings]
          AutoConnect=true

          [@pem@ca_cert]
          ${config.sops.placeholder."eduroam/ca_cert"}

          [@pem@client_cert]
          ${config.sops.placeholder."eduroam/client_cert"}

          [@pem@client_key]
          ${config.sops.placeholder."eduroam/private_key"}
        '';
      };
    };
  };
}
