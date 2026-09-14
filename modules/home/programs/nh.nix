{ config, ... }:

let
  flakeDir = "${config.home.homeDirectory}/nix";
in
{
  programs.nh = {
    enable = true;

    # "path:" prefix to ignore git dirty
    flake = "path:${flakeDir}";
  };
}
