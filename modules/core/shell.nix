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
    if [[ $- == *i* && -t 0 && -z $NU_VERSION ]]; then
      exec nu
    fi
  '';
}
