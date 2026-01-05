{ pkgs, inputs, ... }:
{
  programs.vicinae = {
    enable = true;
    package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd.enable = true;
    extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
      nix
      #power-profile
      hypr-keybinds
    ];
    settings = {
      "$schema" = "https://vicinae.com/schemas/config.json";
    };
  };
}
