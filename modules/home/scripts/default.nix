{
  pkgs,
  username,
  inputs,
  ...
}:
{
  home.packages = [
    (import ./emopicker9000.nix { inherit pkgs; })
    (import ./keybinds.nix { inherit pkgs; })
    (import ./task-waybar.nix { inherit pkgs; })
    (import ./wallsetter.nix {
      inherit pkgs;
      inherit username;
      inherit inputs;
    })
    (import ./rofi-launcher.nix { inherit pkgs; })
    (import ./screenshootin.nix { inherit pkgs; })
  ];
}
