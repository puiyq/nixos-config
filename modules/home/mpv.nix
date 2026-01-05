{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = [ pkgs.mpvScripts.bdanmaku ];
    defaultProfiles = [ "gpu-hq" ];
    config = {
      hwdec = "auto";
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
    };
  };
}
