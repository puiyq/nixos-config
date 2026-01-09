{ pkgs, inputs, ... }:
{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      nix
      hypr-keybinds
    ];
    settings = {
      "$schema" = "https://vicinae.com/schemas/config.json";
    };
  };
}
