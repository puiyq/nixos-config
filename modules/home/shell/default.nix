{ ... }:

{
  imports = [
    ./fish
  ];

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
}
