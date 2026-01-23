{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      mpv-unwrapped = pkgs.mpv-unwrapped.override {
        nv-codec-headers-11 = null;
        alsaSupport = false;
        archiveSupport = false;
        bluraySupport = false;
        bs2bSupport = false;
        cacaSupport = false;
        cmsSupport = false;
        dvbinSupport = false;
        dvdnavSupport = false;
        javascriptSupport = false;
        openalSupport = false;
        pulseSupport = false;
        rubberbandSupport = false;
        vdpauSupport = false;
        x11Support = false;
        zimgSupport = false;
      };
      youtubeSupport = false;
      scripts = with pkgs.mpvScripts; [
        bdanmaku
        mpris
        uosc
        pkgs.uosc-danmaku
      ];
    };
    scriptOpts = {
      uosc = {
        controls = "menu,gap,subtitles,<has_many_audio>audio,<has_many_video>video,<has_many_edition>editions,<stream>stream-quality,button:danmaku_menu,cycle:toggle_on:show_danmaku@uosc_danmaku:on=toggle_on/off=toggle_off?弹幕开关,gap,space,speed,space,shuffle,loop-playlist,loop-file,gap,prev,items,next,gap,fullscreen";
      };
    };
    defaultProfiles = [ "gpu-hq" ];
    config = {
      hwdec = "auto";
      ytdl-format = "bestvideo+bestaudio";
      cache = "yes";
      demuxer-max-bytes = "512MiB";
      demuxer-readahead-secs = 20;
      audio-device = "pipewire";
      gpu-api = "vulkan";
      hwdec-codecs = "all";
      deband = "yes";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "mitchell";
      temporal-dither = "yes";
      video-sync = "display-resample";
      af = "lavfi=[aresample=resampler=soxr]";
    };
  };
  programs.yt-dlp = {
    enable = true;
    package = pkgs.yt-dlp-light;
    settings = {
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x16 -s16 -k1M'";
    };
  };
}
