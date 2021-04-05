eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export _JAVA_AWT_WM_NONREPARENTING=1
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
xgamma -gamma 1.09

xsetroot -cursor_name left_ptr &
picom --experimental-backends &
dunst &
flameshot &
# xscreensaver &
~/.fehbg &
~/.config/polybar/launch.sh &

exec bspwm
