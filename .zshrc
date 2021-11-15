# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
antibody bundle romkatv/powerlevel10k
# eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
