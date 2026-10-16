{
  programs.nushell = {
    enable = true;
    shellAliases = {
      v = "^$env.EDITOR";
    };
    settings = {
      show_banner = false;
      history = {
        file_format = "sqlite";
        max_size = 5000000;
        sync_on_enter = true;
        isolation = true;
      };
      rm.always_trash = true;
    };
    environmentVariables = {
      CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
    };
    configFile.source = ./config.nu;
  };

}
