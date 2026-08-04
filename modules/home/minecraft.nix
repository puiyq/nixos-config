{ pkgs, lib, ... }:
{
  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override {
      additionalPrograms = [ pkgs.ffmpeg ];
      textToSpeechSupport = false;
      jdks = with pkgs; [
        graalvmPackages.graalvm-ce
        zulu
      ];
    };
    settings = {
      Language = "zh";
      BackgroundCat = "rory";
      WrapperCommand = "gamemoderun";
      EnableFeralGamemode = true;
      IgnoreJavaCompatibility = true;
      MaxMemAlloc = 6 * 1024;
      MinMemAlloc = 6 * 1024;
      JvmArgs = lib.concatStringsSep " " [
        "-XX:+UseZGC"
        "-XX:+UseCompactObjectHeaders"
        "-XX:+AlwaysPreTouch"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+UnlockDiagnosticVMOptions"
        "-XX:+DisableExplicitGC"
        "-XX:+PerfDisableSharedMem"
        "-XX:MetaspaceSize=128M"
        "-XX:MaxMetaspaceSize=512M"
        "-Dorg.lwjgl.sdl.libname=${pkgs.sdl3.lib}/lib/libSDL3.so"
      ];
    };
  };
}
