{ shellDefault, ... }:
{
  imports = [ (./. + "/${shellDefault}") ];

  programs = {
    carapace.enable = true;
    atuin = {
      enable = true;
      flags = [ "--disable-ctrl-r" ];
      settings = {
        style = "auto";
        command_chaining = true;
        enter_accept = true;
        prefers_reduced_motion = true;
        sync.records = true;
      };
    };
  };

  home.shellAliases = {
    sv = "sudoedit";
    v = "nvim";
    c = "clear";
    f = "clear && microfetch";
    man = "batman";
    curl = "curlie";
    cat = "bat";
    nix-shell = "nom-shell";
    nix-build = "nom-build";
  };
}
