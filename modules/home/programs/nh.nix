{ pkgs, user, ... }:

let
  flakeDir = (if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}") + "/nix";
in
{
  programs.nh = {
    enable = true;

    # "path:" prefix to ignore git dirty
    flake = "path:${flakeDir}";
  };
}
