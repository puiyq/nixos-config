{ pkgs, ... }:
{
  home = {
    shell.enableFishIntegration = true;
    packages = with pkgs; [
      babelfish # workaround of https://github.com/NixOS/nixpkgs/issues/440098
      grc
    ];
  };

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
      v = "$EDITOR";
      f = "clear && microfetch";
      curl = "curlie";
      ls = "eza";
      lt = "eza --tree --level=2";
      ll = "eza  -lh --no-user --long";
      la = "eza -lah ";
      tree = "eza --tree ";
    };
  };
}
