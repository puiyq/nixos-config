{
  programs.starship = {
    enable = true;
    presets = [
      "catppuccin-powerline"
      "nerd-font-symbols"
    ];
    settings = fromTOML (builtins.readFile ./settings.toml);
  };
}
