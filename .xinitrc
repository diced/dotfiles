eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export _JAVA_AWT_WM_NONREPARENTING=1
export ELECTRON_TRASH=kioclient5
export MESA_GL_VERSION_OVERRIDE=4.3
export QT_STYLE_OVERRIDE=kvantum

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

xsetroot -cursor_name left_ptr &
picom --experimental-backends &
flameshot &
~/.fehbg &
~/.config/polybar/launch.sh &
tint2 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
GDK_BACKEND=x11 ulauncher --hide-window --no-window-shadow &

exec bspwm
