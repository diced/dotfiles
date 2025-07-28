{ pkgs, user, ... }:

{
  imports = [
    ../terminal
    ../direnv.nix
    ../eza.nix
    ../fzf.nix
    ../zoxide.nix
  ];

  home = {
    username = user;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
  };

  news.display = "silent";
}
