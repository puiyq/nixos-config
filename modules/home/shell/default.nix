{
  imports = [
    # ./fish
    ./bash
  ];

  programs = {
    carapace.enable = true;
    atuin = {
      enable = false;
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
