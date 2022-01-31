#!/bin/sh

BLANK='#00000000'
CLEAR='#3b404a'
DEFAULT='#1b1e24'
TEXT='#ffffff'
WRONG='#3498db'
VERIFYING='#3498db'

i3lock \
-i ~/.config/solid_bg.png \
--bar-indicator \
--bar-pos x+w-1110:y+h-500 \
--bar-direction 0 \
--bar-max-height 10 \
--bar-base-width 10 \
--bar-total-width 300 \
--bar-color 1b1e24 \
--keyhl-color 3498db \
--bar-periodic-step 50 \
--bar-step 50 \
--redraw-thread \
\
--clock \
--date-color ffffff \
--date-str "%A %B %C" \
--force-clock \
--time-color ffffff \
--time-str "%I:%M %p" \
--ringver-color 3498db \
--ringwrong-color f71616 \
--status-pos x+5:y+h-16 \
--verif-align 1 \
--wrong-align 1 \
--verif-color ffffffff \
--wrong-color ffffffff \
--modif-pos -50:-50 \
\
--time-font "Jetbrains Mono Nerd Font" \
--date-font "Jetbrains Mono Nerd Font" \
--verif-font "Jetbrains Mono Nerd Font" \
--wrong-font "Jetbrains Mono Nerd Font" \
--greeter-font="Jetbrains Mono Nerd Font";

sudo systemctl restart bluetooth.service
