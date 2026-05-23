{ lib, pkgs, ... }:

{

  home = {
    packages = with pkgs; [
      zsh
    ];

    shellAliases = {
      "p" = "pnpm";
      "pa" = "pnpm add";
      "pad" = "pnpm add -D";
      "pd" = "pnpm dev";
      "pns" = "pnpm start";
      "pb" = "pnpm build";

      "nd" = "nix-develop";

      "reload-p10k" = "source ${./p10k.zsh}";
    };
  };

  programs.zsh = {
    enable = true;
    history = {
      size = 1000000;
      append = true;
      ignoreAllDups = true;
      extended = true;
      share = true;
    };

    plugins = [
      {
        name = "fast-syntax-highlighting";
        file = "F-Sy-H.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "3bd4aa2450066f86b6a61e0426a50ac8b42061aa";
          sha256 = "sha256-RKybDFJ7P0AySVebHGilm10pf5VYu4CZGib+TgnpTAE=";
        };
      }
    ];

    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    historySubstringSearch.enable = true;
    enableCompletion = true;

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        if [[ -r "~/.cache/p10k-instant-prompt-''\${(%):-%n}.zsh" ]]; then
          source "~/.cache/p10k-instant-prompt-''\${(%):-%n}.zsh"
        fi

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        if [ -f ${./p10k.zsh} ]; then source ${./p10k.zsh};
        else
          source /etc/powerlevel10k/.p10k.zsh
        fi
      '')
      ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey "[[3~" delete-char
        bindkey "^H" backward-kill-word
        bindkey "^[[3;5~" kill-word

        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' list-colors 'no=00:fi=00:di=01;34:ln=36:pi=33:so=35:bd=01;33:cd=01;33:or=31:mi=01;05;37:su=37:sg=32:tw=34:ow=34'

        nix-develop() {
          nix develop --command zsh
        }

        where() { readlink -f "$(which "$@")"; }
      ''
    ];
  };
}
