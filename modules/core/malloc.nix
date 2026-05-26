{
  pkgs,
  lib,
  config,
  username,
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
        executable = lib.getExe config.home-manager.users.${username}.programs.prismlauncher.package;
        profile = "${pkgs.firejail}/etc/firejail/prismlauncher.profile";
        extraArgs = [
          "--blacklist=/etc/ld-nix.so.preload"
        ];
      };
    };
  };
}
