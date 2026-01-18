{ pkgs, user, ... }:

{
  imports = [
    ../shell
    ../programs/terminal/direnv.nix
    ../programs/terminal/eza.nix
    ../programs/terminal/fzf.nix
    ../programs/terminal/zoxide.nix
    ../programs/terminal/tealdeer.nix
    ../programs/terminal/fastfetch.nix
    ../programs/terminal/rg.nix
    ../programs/gpg.nix
  ];

  home = {
    username = user;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
  };

  news.display = "silent";
}
