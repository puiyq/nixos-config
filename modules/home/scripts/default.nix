{
  pkgs,
  ...
}:
{
  home.packages = [
    (import ./task-waybar.nix { inherit pkgs; })
    (import ./screenshootin.nix { inherit pkgs; })
  ];
}
