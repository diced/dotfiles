{ pkgs, ... }:

{
  imports = [
    ../terminal
  ];

  home = {
    username = "diced";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/diced" else "/home/diced";
  };

  news.display = "silent";
}
