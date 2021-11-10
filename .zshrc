export PATH=~/.local/bin:/usr/local/bin:~/.n/bin:$PATH
export ZSH="/home/diced/.oh-my-zsh"

typeset -gA ZSH_HIGHLIGHT_STYLES

# vars
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export DISABLE_AUTO_UPDATE=true
export CASE_SENSITIVE="false"
export PF_INFO="ascii title os wm shell editor kernel uptime pkgs memory"
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=cyan
#export ZSH_HIGHLIGHT_STYLES[arg1]=fg=blue,underline
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export N_PREFIX=~/.n
# uploaders
export ZIP_AUTH=$(cat ~/.zip_auth)
export VCH_AUTH=$(cat ~/.vch_auth)
export RIMG_AUTH=$(cat ~/.rimg_auth)

# aliases
alias config='/usr/bin/git --git-dir=/home/diced/.cfg/ --work-tree=/home/diced'
alias ls='ls --color=auto'

# bind
bindkey '^H' backward-kill-word

# antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins

eval "$(starship init zsh)"
if [ -e /home/diced/.nix-profile/etc/profile.d/nix.sh ]; then . /home/diced/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
