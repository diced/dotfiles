if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -gA ZSH_HIGHLIGHT_STYLES

export HISTFILE=~/.zsh_history
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export DISABLE_AUTO_UPDATE=true
export CASE_SENSITIVE="false"

path+=(
  "$HOME/.local/bin"
  "$HOME/.n/bin"
  "$HOME/scripts"
)
export PATH
export N_PREFIX=~/.n

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias ls='ls --color=auto'

bindkey '^H' backward-kill-word
bindkey "^[[3~" delete-char
bindkey ";5C" forward-word
bindkey ";5D" backward-word

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

source <(antibody init)
antibody bundle < ~/.zsh_plugins

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
