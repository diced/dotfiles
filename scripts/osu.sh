#!/bin/sh

unzip "$1" -d "/media/games/osu/drive_c/osu/Songs/$(basename "${1%.osz}")"
