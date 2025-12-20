{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = false;
    libraries = with pkgs; [
      (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      ##############
      # Core system
      ##############
      stdenv.cc.cc # C/C++ runtime
      glib # Core GNOME/GTK runtime
      libgcc.lib
      zlib
      zstd
      bzip2
      #zulu8
      #zulu17
      #zulu
      libarchive
      libssh
      openssl
      libsodium
      libxml2
      systemd
      attr
      acl
      util-linux
      curl
      icu
      expat
      libelf

      ##################
      # X11 / graphics
      ##################
      xorg.libX11
      xorg.libXext
      xorg.libXfixes
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXrandr
      xorg.libXi
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libSM
      xorg.libICE
      xorg.libXt
      xorg.libXmu
      xorg.libxshmfence
      xorg.libXxf86vm

      libglvnd
      libGLU # Needed by some X11 OpenGL apps
      libvdpau
      pixman

      ##################
      # Wayland / media
      ##################
      pipewire
      ffmpeg
      alsa-lib

      ##################
      # GTK / GNOME / desktop
      ##################
      gtk2
      gtk3
      pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      libnotify
      gsettings-desktop-schemas
      dbus
      dbus-glib
      #gnome2.GConf
      libcanberra
      #libindicator-gtk2
      #libappindicator-gtk2
      #libdbusmenu-gtk2

      ##################
      # SDL / games / multimedia
      ##################
      #SDL
      SDL2
      #SDL_image
      SDL2_image
      #SDL_ttf
      #SDL2_ttf
      #SDL_mixer
      #SDL2_mixer
      libogg
      libvorbis
      flac
      libsamplerate
      #libmikmod
      libtheora
      libvpx
      libjpeg
      libpng
      #libpng12
      libtiff
      #glew110

      ##################
      # System / utilities / hardware
      ##################
      libusb1
      fuse
      btrfs-progs
      libxkbcommon # For Blender and keyboard support

      ##################
      # Optional / legacy / rarely used (commented out)
      ##################
      libtheora # For very old media apps
      # libmikmod             # For very old game music formats
      cups # Printing support
      # libxcrypt-legacy      # Legacy X apps (Natron)
      nspr
      nss # Needed by Firefox/Chrome / TLS apps
    ];
  };
}
