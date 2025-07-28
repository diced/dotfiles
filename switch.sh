#!/usr/bin/env bash

set -e

usage_str="Usage: $0 [darwin|nixos|home] [-h]"

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "$usage_str"
  exit 1
fi

TARGET="$1"
SWITCH_HOME=false

if [ "$2" == "-h" ]; then
  SWITCH_HOME=true
fi

# load in config
CONFIG_FILE="$HOME/nix/config.sh"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi
source "$CONFIG_FILE"

# variables needed in config.sh:
# FLAKE_DIR, path to flake dir ("$HOME/nix")
# CONFIG_NAME, name of the configuration ("macbook-pro")

FLAKE="$FLAKE_DIR#$CONFIG_NAME"

switch_home() {
  
    echo "Running home-manager..."
    home-manager switch --flake "$FLAKE"
}

case "$TARGET" in
  nixos|n)
    echo "Running nixos-rebuild..."
    sudo nixos-rebuild switch --flake "$FLAKE"
    ;;
  darwin|d)
    echo "Running darwin-rebuild..."
    sudo darwin-rebuild switch --flake "$FLAKE"
    ;;
  home|h)
    switch_home
    ;;
  *)
    echo "Unknown target: $TARGET"
    echo "$usage_str"
    exit 1
    ;;
esac

if $SWITCH_HOME && [[ "$TARGET" != "home" ]]; then
  switch_home
fi
