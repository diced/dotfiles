#!/bin/sh

unzip "$1" -d "$HOME/games/osu/drive_c/osu/Songs/$(basename "${1%.osz}")"
