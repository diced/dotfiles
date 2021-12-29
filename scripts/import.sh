#!/bin/sh

echo "> git clone https://github.com/diced/dotfiles"
git clone --bare https://github.com/diced/dotfiles $HOME/.cfg
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

# todo: install paru and install all packages
