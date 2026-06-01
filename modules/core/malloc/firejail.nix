{
  pkgs,
  lib,
  ...
}:
let
  getProfile = profileName: "${pkgs.firejail}/etc/firejail/${profileName}.profile";
  getDesktopItem = package: desktopName: "${package}/share/applications/${desktopName}.desktop";
  mkWrappedBinary =
    {
      package,
      executable ? lib.getExe package,
      profileName ? package.pname or "noprofile",
      desktopName ? package.pname,
      profile ? getProfile profileName,
      desktop ? getDesktopItem package desktopName,
      extraArgs ? [ ],
    }:
    {
      inherit
        executable
        profile
        desktop
        extraArgs
        ;
    };
in
{
  environment.memoryAllocator.provider = "mimalloc";

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      vivaldi = mkWrappedBinary {
        package = pkgs.vivaldi.override { proprietaryCodecs = true; };
        desktopName = "vivaldi-stable";
        profileName = "noprofile";
        extraArgs = [
          "--blacklist=/etc/ld-nix.so.preload"
          "--ignore=nou2f"
        ];
      };
      prismlauncher = mkWrappedBinary {
        package = pkgs.prismlauncher.override {
          additionalPrograms = [ pkgs.ffmpeg ];
          textToSpeechSupport = false;
          jdks = [ pkgs.graalvmPackages.graalvm-ce ];
        };
        desktopName = "org.prismlauncher.PrismLauncher";
        profileName = "noprofile";
        extraArgs = [
          "--blacklist=/etc/ld-nix.so.preload"
        ];
      };
      zotero = mkWrappedBinary {
        package = pkgs.zotero;
        profileName = "noprofile";
        extraArgs = [
          "--blacklist=/etc/ld-nix.so.preload"
        ];
      };
    };
  };
}
