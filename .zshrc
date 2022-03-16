if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi;

if [[ -r "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$HOME/.cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -gA ZSH_HIGHLIGHT_STYLES

path+=(
  "$HOME/.local/bin"

  "$HOME/.n/bin"
  "$HOME/scripts"
)

export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export N_PREFIX=~/.n
export EDITOR=nano
export PATH

alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias ls='ls --color=auto'

bindkey '^H' backward-kill-word
bindkey '5~' kill-word

setopt correct

source <(antibody init)
antibody bundle < ~/.zsh_plugins

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
