{
  pkgs,
  lib,
  ...
}:
{
  environment.memoryAllocator.provider = "mimalloc";

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      vivaldi = {
        executable = lib.getExe (pkgs.vivaldi.override { proprietaryCodecs = true; });
        profile = "${pkgs.firejail}/etc/firejail/vivaldi.profile";
        extraArgs = [
          "--blacklist=/etc/ld-nix.so.preload"
        ];
      };
      prismlauncher = {
        profile = "${pkgs.firejail}/etc/firejail/prismlauncher.profile";
        executable = lib.getExe (
          pkgs.prismlauncher.override {
            additionalPrograms = [ pkgs.ffmpeg ];
            textToSpeechSupport = false;
            jdks = [ pkgs.graalvmPackages.graalvm-ce ];
          }
        );
        extraArgs = [
          "--blacklist=/etc/ld-nix.so.preload"
        ];
      };
    };
  };
}
