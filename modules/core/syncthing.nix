let
  username = "puiyq";
in
{
  services.syncthing = {
    enable = false;
    user = "${username}";
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
  };
}
