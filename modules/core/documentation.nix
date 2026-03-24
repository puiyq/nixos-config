{ username, ... }:

{
  documentation = {
    info.enable = false;
    nixos.enable = false;
    doc.enable = false;
  };
  home-manager.users.${username} = {
    programs.man.generateCaches = false;
    manual.manpages.enable = false;
  };
}
