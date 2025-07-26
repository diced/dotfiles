{ pkgs, ... }:

{
  imports = [
    ./starship
  ];

  home.packages = with pkgs; [
    zsh
    eza
    zoxide
    fastfetch
    fzf
    tealdeer
  ];

  home.shellAliases = {
    "ls" = "eza";

    "p" = "pnpm";
    "pa" = "pnpm add";
    "pad" = "pnpm add -D";
    "pd" = "pnpm dev";
    "ps" = "pnpm start";
    "pb" = "pnpm build";
  };

  programs = {
    zsh = {
      enable = true;
      history = {
        size = 1000000;
        append = true;
        ignoreAllDups = true;
        extended = true;
        share = true;
      };

      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
      };

      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey "[[3~" delete-char
        bindkey "^H" backward-kill-word
        bindkey "^[[3;5~" kill-word
      '';
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}