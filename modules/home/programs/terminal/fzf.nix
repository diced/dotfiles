{ ... }:

{
  programs.fzf = {
    # ctrl + r to search history
    # ctrl + t to search cwd

    enable = true;
    enableZshIntegration = true;
  };
}
