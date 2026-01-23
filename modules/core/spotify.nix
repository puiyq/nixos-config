{
  inputs,
  pkgs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.spicetify-nix.nixosModules.default ];

  programs.spicetify = {
    enable = true;
    wayland = true;
    windowManagerPatch = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      aiBandBlocker
      betterGenres
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
  };
}
