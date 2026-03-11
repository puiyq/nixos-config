{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.zed-editor.languages.nix;
  self = "(builtins.getFlake \"${config.home.homeDirectory}/nixos-config\")";
  system = "${self}.nixosConfigurations.nixos";
  home = "${system}.options.home-manager.users.type";
  settings = {
    formatting.command = lib.getExe pkgs.nixfmt;
    nixpkgs.expr = "${system}._module.args.pkgs";
    options = {
      nixos.expr = "${system}.options";
      home-manager.expr = "${home}.getSubOptions []";
    };
  };
in
{
  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      extraPackages = [ pkgs.nixd ];
      extensions = [ "nix" ];

      userSettings = {
        lsp = {
          nixd = { inherit settings; };
        };

        languages = {
          Nix = {
            language_servers = [
              "nixd"
              "!nil"
            ];
          };
        };
      };
    };
  };
}
