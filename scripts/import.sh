#!/bin/sh

echo "> git clone https://github.com/diced/dotfiles"
git clone --bare https://github.com/diced/dotfiles $HOME/.cfg
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

# todo: install paru and install all packages

# ask if they want to install gnome specific settings
read -p "Would you like to install gnome specific settings? [y/N] " -n 1 -r
echo
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "> sh $HOME/scripts/import-gnome-cloned.sh";
  sh $HOME/scripts/import-gnome-cloned.sh
else
  echo "Skipping gnome settings, bspwm will work out of the box.";
fi