#!/bin/sh

git clone --bare https://github.com/diced/dotfiles $HOME/.cfg
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
