eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export _JAVA_AWT_WM_NONREPARENTING=1
export ELECTRON_TRASH=gio
export MESA_GL_VERSION_OVERRIDE=4.3
export QT_QPA_PLATFORMTHEME=gtk2

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
xset +fp /home/diced/.fonts
xset fp rehash
xrandr --dpi 96 &

xsetroot -cursor_name left_ptr &
picom --experimental-backends &
dunst &
flameshot &
~/.fehbg &
~/.config/polybar/launch.sh &
exec bspwm
