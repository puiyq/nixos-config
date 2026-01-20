{ pkgs, ... }:
{
  programs.uv = {
    enable = false;
    package = pkgs.uv;
    settings = { };
  };
}
