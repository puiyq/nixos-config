{ inputs, username, ... }:
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  programs.noctalia-greeter.enable = true;

  services.greetd.settings.default_session.user = username;
}
