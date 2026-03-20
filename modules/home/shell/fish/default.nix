{
  pkgs,
  lib,
  shellDefault,
  ...
}:
{
  config = lib.mkIf (shellDefault == "fish") {
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

      interactiveShellInit = "set fish_greeting # Disable greeting";

      functions = {
        nix = ''
          function nix
            switch $argv[1]
              case shell develop build
                nom $argv
              case '*'
                command nix $argv
            end
          end
        '';
      };
    };
  };
}
