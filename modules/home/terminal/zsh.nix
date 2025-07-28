{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    fastfetch
    tealdeer
  ];

  home.shellAliases = {
    "p" = "pnpm";
    "pa" = "pnpm add";
    "pad" = "pnpm add -D";
    "pd" = "pnpm dev";
    "pns" = "pnpm start";
    "pb" = "pnpm build";
  };

  programs = {
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      # ctrl + r to search history
      # ctrl + t to search cwd

      enable = true;
      enableZshIntegration = true;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

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

      initContent = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey "[[3~" delete-char
        bindkey "^H" backward-kill-word
        bindkey "^[[3;5~" kill-word


        nix-develop() {
          nix develop --command zsh
        }
        nix-run() {
          NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "nixpkgs#$1" \
            --command sh -c "which ''${1#*.} &>/dev/null && exec ''${1#*.} ''${*:2}; exec ''${*:2}"
        }
        nix-shell() {(
          ARGS=()
          for i in "$@"; do
            if [[ -n $OPTION || $i[1] = - ]]; then
              ARGS+=$i OPTION=1
              continue
            fi
            ARGS+="nixpkgs#$i"
          done
          IN_NIX_SHELL=impure NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "''${ARGS[@]}"
        )}
        where() { readlink -f "$(which "$@")"; }
      '';
    };
  };
}
