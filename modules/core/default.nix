{ ... }:
{
  imports = [
    ./i686.nix
    ./patches.nix
    ./nix-ld.nix
    ./boot.nix
    ./fonts.nix
    ./sddm.nix
    ./hardware.nix
    ./network.nix
    ./nh.nix
    ./packages.nix
    ./printing.nix
    ./security.nix
    ./services.nix
    ./starship.nix
    ./steam.nix
    ./stylix.nix
    ./syncthing.nix
    ./system.nix
    ./user.nix
    ./virtualisation.nix
    ./shell.nix
    #./ollama.nix
    #./location.nix
  ];
}
