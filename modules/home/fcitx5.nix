{ pkgs, ... }:
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = [
            rime-ice
            rime-zhwiki
            rime-moegirl
            rime-data
          ];
        })
      ];
      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
        };
        globalOptions = {
          "Hotkey/PrevPage"."0" = "braceleft";
          "Hotkey/NextPage"."0" = "braceright";
          Behavior.DefaultPageSize = 10;
        };
        addons = {
          imselector.sections.SwitchKey = {
            "0" = "Super+braceright";
            "1" = "Super+braceleft";
          };
        };
      };
    };
  };
}
