eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export _JAVA_AWT_WM_NONREPARENTING=1
export ELECTRON_TRASH=gio
export MESA_GL_VERSION_OVERRIDE=4.3
export QT_STYLE_OVERRIDE=kvantum
export BROWSER=brave

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
xset +fp /home/diced/.fonts
xset fp rehash
xrandr --dpi 96 &

xsetroot -cursor_name left_ptr &
picom --experimental-backends &
flameshot &
fehbg &
~/.config/polybar/launch.sh &
xfce4-volumed-pulse &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
GDK_BACKEND=x11 ulauncher --hide-window --no-window-shadow &

alacritty &
brave &

sudo systemctl start docker &

exec bspwm 
