{ pkgs, ... }:
let
  settings = import ./yazi.nix;
  keymap = import ./keymap.nix;
  theme = import ./theme.nix;
in
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    inherit settings keymap theme;
    plugins = {
      inherit (pkgs.yaziPlugins)
        full-border
        smart-enter
        mount
        ;
    };

    initLua = ''
      require("full-border"):setup()
         require("smart-enter"):setup {
           open_multi = true,
         }
    '';
  };
}
