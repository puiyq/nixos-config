{ pkgs, ... }: {
  environment = {
    systemPackages = [
      pkgs.nushell
    ];
    shells = [
      pkgs.nushell
    ];
  };

  programs.bash.interactiveShellInit = ''
    if ! [ "$TERM" = "dumb" ]; then
      exec nu
    fi
  '';
}
