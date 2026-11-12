{ pkgs, lib, ... }:
{
  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override {
      additionalPrograms = [ pkgs.ffmpeg ];
      textToSpeechSupport = false;
      jdks = with pkgs; [
        graalvmPackages.graalvm-oracle
        zulu
      ];
    };
    settings = {
      Language = "zh";
      BackgroundCat = "rory";
      WrapperCommand = "gamemoderun";
      IgnoreJavaCompatibility = true;
      MaxMemAlloc = 6 * 1024;
      MinMemAlloc = 6 * 1024;
      JvmArgs = lib.concatStringsSep " " [
        "-XX:+UseZGC"
        "-XX:+UseCompactObjectHeaders"
        "-XX:+AlwaysPreTouch"
        "-XX:+UseTransparentHugePages"
        "-XX:+EagerJVMCI"
        "-Djdk.graal.CompilerConfiguration=enterprise"
        "-Djdk.graal.TuneInlinerExploration=1"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+UnlockDiagnosticVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+PerfDisableSharedMem"
        "-XX:MetaspaceSize=128M"
        "-Dorg.lwjgl.sdl.libname=${pkgs.sdl3.lib}/lib/libSDL3.so"
      ];
    };
  };
}
