{
  user,
  pkgs,
  lib,
  host,
  ...
}:

let
  home = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${user}" else "/home/${user}";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "sandbox" = {
        hostname = "sandbox";
        user = "codex";
      };

      "*" = lib.mkIf (host == "macbook-pro") {
        addKeysToAgent = true;
        useKeychain = true;
        identityFile = "${home}/.ssh/macbook_pro";
      };

      "github.com" = {
        hostname = "github.com";
        identityFile = "${home}/.ssh/github";
        identitiesOnly = true;
      };
      "github-edu" = {
        hostname = "github.com";
        identityFile = "${home}/.ssh/github_edu";
        identitiesOnly = true;
      };
    };
  };
}
