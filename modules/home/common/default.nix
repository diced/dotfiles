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
    ../programs/ssh.nix
    ../programs/nh.nix
    ../utils/switch.nix
  ];

  # User identity and home directory come from the system's user definition.
  home.stateVersion = "26.05";

  news.display = "silent";
}
