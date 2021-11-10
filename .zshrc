export ZSH="$HOME/.oh-my-zsh"

typeset -gA ZSH_HIGHLIGHT_STYLES

# vars
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export DISABLE_AUTO_UPDATE=true
export CASE_SENSITIVE="false"
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=cyan

path+=(
  "$HOME/.local/bin"
  "$HOME/.n/bin"
  "$HOME/scripts"
)
export PATH

export N_PREFIX=~/.n

# aliases
alias config='/usr/bin/git --git-dir=/home/diced/.cfg/ --work-tree=/home/diced'
alias ls='ls --color=auto'

# bind
bindkey '^H' backward-kill-word

# antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins

eval "$(starship init zsh)"

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
