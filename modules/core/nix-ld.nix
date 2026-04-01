{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = false;
    libraries = with pkgs; [
      (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      ##############
      # Core system
      ##############
      # keep-sorted start
      acl
      attr
      bzip2
      curl
      expat
      glib # Core GNOME/GTK runtime
      icu
      libarchive
      libelf
      libgcc.lib
      libsodium
      libssh
      libxml2
      openssl
      stdenv.cc.cc # C/C++ runtime
      systemd
      util-linux
      zlib
      zstd
      # keep-sorted end

      ##################
      # X11 / graphics
      ##################
      # keep-sorted start

      libGLU # Needed by some X11 OpenGL apps
      libglvnd
      libice
      libsm
      libvdpau
      libx11
      libxScrnSaver
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxinerama
      libxmu
      libxrandr
      libxrender
      libxshmfence
      libxt
      libxxf86vm
      pixman
      # keep-sorted end

      ##################
      # Wayland / media
      ##################
      # keep-sorted start
      alsa-lib
      ffmpeg
      pipewire
      # keep-sorted end

      ##################
      # GTK / GNOME / desktop
      ##################
      # keep-sorted start
      atk
      cairo
      dbus
      dbus-glib
      fontconfig
      freetype
      gdk-pixbuf
      gsettings-desktop-schemas
      gtk2
      gtk3
      libcanberra
      libnotify
      pango
      # keep-sorted end

      ##################
      # SDL / games / multimedia
      ##################
      # keep-sorted start
      SDL2
      SDL2_image
      flac
      libjpeg
      libogg
      libpng
      libsamplerate
      libtheora
      libtiff
      libvorbis
      libvpx
      # keep-sorted end

      ##################
      # System / utilities / hardware
      ##################
      # keep-sorted start
      btrfs-progs
      fuse
      libusb1
      libxkbcommon # For Blender and keyboard support
      # keep-sorted end

      ##################
      # Optional / legacy / rarely used (commented out)
      ##################
      # keep-sorted start
      cups # Printing support
      libtheora # For very old media apps
      nspr
      nss # Needed by Firefox/Chrome / TLS apps
      # keep-sorted end
    ];
  };
}
