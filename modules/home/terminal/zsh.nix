{ pkgs, ... }:

{
  imports = [
    ../zoxide.nix
    ../fzf.nix
    ../eza.nix
  ];

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
    "cd" = "z";
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

    antidote = {
      enable = true;
      plugins = [
        "zdharma-continuum/fast-syntax-highlighting"
      ];
    };

    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    historySubstringSearch.enable = true;
    enableCompletion = true;

    initContent = ''
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
}
