{ user, pkgs, ... }:

let
  home = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        addKeysToAgent = true;
        useKeychain = true;
        identityFile = "${home}/.ssh/macbook_pro";
      };

      "github.com" = {
        hostname = "github.com";
        identityFile = "${home}/.ssh/github";
      };
      "github-edu" = {
        hostname = "github.com";
        identityFile = "${home}/.ssh/github_edu";
      };
    };
  };
}
