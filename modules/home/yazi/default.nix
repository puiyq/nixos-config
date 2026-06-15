{ pkgs, ... }:
let
  settings = import ./yazi.nix;
  keymap = import ./keymap.nix;
  theme = import ./theme.nix;
in
{
  programs.yazi = {
    enable = true;
    inherit settings keymap theme;
    plugins = {
      mount = pkgs.yaziPlugins.mount;
      full-border = {
        package = pkgs.yaziPlugins.full-border;
        setup = true;
      };
      smart-enter = {
        package = pkgs.yaziPlugins.smart-enter;
        setup = true;
        settings = {
          open_multi = true;
        };
      };
    };
  };
}
