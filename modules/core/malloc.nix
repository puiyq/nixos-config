{
  pkgs,
  lib,
  ...
}:
let
  getProfile = profileName: "${pkgs.firejail}/etc/firejail/${profileName}.profile";
in
{
  environment.memoryAllocator.provider = "mimalloc";

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      vivaldi = {
        executable = lib.getExe (pkgs.vivaldi.override { proprietaryCodecs = true; });
        profile = getProfile "vivaldi";
        extraArgs = [
          "--blacklist=/etc/ld-nix.so.preload"
          "--ignore=nou2f"
        ];
      };
      prismlauncher = {
        executable = lib.getExe (
          pkgs.prismlauncher.override {
            additionalPrograms = [ pkgs.ffmpeg ];
            textToSpeechSupport = false;
            jdks = [ pkgs.graalvmPackages.graalvm-ce ];
          }
        );
        profile = getProfile "prismlauncher";
        extraArgs = [
          "--blacklist=/etc/ld-nix.so.preload"
        ];
      };
    };
  };
}
