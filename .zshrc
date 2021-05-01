export PATH=~/.local/bin:/usr/local/bin:$PATH
export ZSH="/home/diced/.oh-my-zsh"

# vars
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export DISABLE_AUTO_UPDATE=true
export CASE_SENSITIVE="false"
export PF_INFO="ascii title os wm shell editor kernel uptime pkgs memory"

# uploaders
export ZIP_AUTH=$(cat ~/.zip_auth)
export VCH_AUTH=$(cat ~/.vch_auth)
export RIMG_AUTH=$(cat ~/.rimg_auth)

# aliases
alias config='/usr/bin/git --git-dir=/home/diced/.cfg/ --work-tree=/home/diced'
alias yay='paru'
alias ls='ls --color=auto'

# bind
bindkey '^H' backward-kill-word

# antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins
source $HOME/.cargo/env

eval "$(starship init zsh)"
