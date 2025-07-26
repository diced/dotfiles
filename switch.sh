#!/usr/bin/env bash

set -e

usage_str="Usage: $0 [darwin|nixos|home]"

if [ "$#" -ne 1 ]; then
  echo "$usage_str"
  exit 1
fi

TARGET="$1"

# load in config
source ./config.sh
# variables needed in config.sh:
# FLAKE_DIR, path to flake dir ("$HOME/nix")
# CONFIG_NAME, name of the configuration ("macbook-pro")

FLAKE="$FLAKE_DIR#$CONFIG_NAME"

case "$TARGET" in
  nixos)
    echo "Running nixos-rebuild..."
    sudo nixos-rebuild switch --flake "$FLAKE"
    ;;
  darwin)
    echo "Running darwin-rebuild..."
    sudo darwin-rebuild switch --flake "$FLAKE"
    ;;
  home)
    echo "Running home-manager..."
    home-manager switch --flake "$FLAKE"
    ;;
  *)
    echo "Unknown target: $TARGET"
    echo "$usage_str"
    exit 1
    ;;
esac
