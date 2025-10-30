{ pkgs, user, ... }:

{
  imports = [
    ../terminal
    ../programs/direnv.nix
    ../programs/eza.nix
    ../programs/fzf.nix
    ../programs/zoxide.nix
    ../programs/tealdeer.nix
    ../programs/fastfetch.nix
    ../programs/rg.nix
    ../programs/gpg.nix
    # ../programs/terminal/zellij
  ];

  home = {
    username = user;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${user}" else "/home/${user}";
  };

  news.display = "silent";
}
