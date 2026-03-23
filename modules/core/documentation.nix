{ username, ... }:

{
  documentation = {
    info.enable = false;
    nixos.enable = false;
    doc.enable = false;
  };
  home-manager.users.${username}.manual.manpages.enable = false;
}
