{ pkgs, ... }:
{
  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override {
      additionalPrograms = [ pkgs.ffmpeg ];
      textToSpeechSupport = false;
      jdks = [ pkgs.graalvmPackages.graalvm-ce ];
    };
    settings = {
      Language = "zh";
      BackgroundCat = "rory";
      WrapperCommand = "gamemoderun";
      EnableFeralGamemode = true;
      IgnoreJavaCompatibility = true;
      MaxMemAlloc = 6 * 1024;
      MinMemAlloc = 6 * 1024;
      JvmArgs = "-XX:+UseZGC -XX:+UseCompactObjectHeaders -XX:+AlwaysPreTouch -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+DisableExplicitGC -XX:+PerfDisableSharedMem -XX:MetaspaceSize=128M -XX:MaxMetaspaceSize=512M";
    };
  };
}
