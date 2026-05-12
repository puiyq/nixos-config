{ pkgs, ... }:
{
  home.shell.enableFishIntegration = true;

  programs.fish = {
    enable = true;

    plugins =
      map
        (pluginName: {
          name = pluginName;
          inherit (pkgs.fishPlugins.${pluginName}) src;
        })
        [
          "grc"
          "tide"
        ];

    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      batman --export-env | source

      function nix
        switch $argv[1]
          case shell develop build
            nom $argv
          case '*'
            command nix $argv
          end
      end
    '';

    shellAliases = {
      v = "nvim";
      c = "clear";
      f = "clear && microfetch";
      curl = "curlie";
      cat = "bat";
      nix-shell = "nom-shell";
      nix-build = "nom-build";
    };
  };
}
