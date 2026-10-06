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
    extraConfig = ''
      def nix [...args: string] {
        match ($args | first | default "") {
          "shell" | "develop" | "build" => { nom ...$args }
          _ => { ^nix ...$args }
        }
      }
    '';
  };

}
