if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then startx; fi;

if [[ -r "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -gA ZSH_HIGHLIGHT_STYLES

path+=(
  "$HOME/.local/bin"

  "$HOME/.n/bin"
  "$HOME/scripts"
)
export HISTSIZE=50000000
export SAVEHIST=50000000
export HISTFILE=~/.zsh_history
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export N_PREFIX=~/.n
export ZSH_CACHE_DIR=~/.cache/zsh
export EDITOR=nano
export PATH

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias ls='ls --color=auto'

bindkey '^H' backward-kill-word
bindkey '5~' kill-word
bindkey "^[[3~" delete-char
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
setopt auto_menu
setopt complete_in_word
setopt always_to_end
unsetopt menu_complete
unsetopt flowcontrol

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

source <(antibody init)
antibody bundle < ~/.zsh_plugins

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
