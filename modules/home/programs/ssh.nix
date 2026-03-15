{ user, pkgs, ... }:

let
  home = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "${home}/.ssh/github";
      };
    };
  };
}
