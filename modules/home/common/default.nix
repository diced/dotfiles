{ pkgs, user, ... }:

{
  imports = [
    ../terminal
  ];

  home = {
    username = user;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
  };

  news.display = "silent";
}
