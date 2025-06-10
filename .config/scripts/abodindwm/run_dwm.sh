#!/bin/sh

xrdb merge ~/.Xresources &
xbacklight -set 10 &
xrandr --output HDMI-1 --left-of eDP-1
xrandr --output eDP-1 --set TearFree on
#nitrogen --restore
feh --bg-fill ~/Pictures/yukimi.jpg &
#feh --bg-fill ~/Pictures/wollpeper/chne.jpeg &
#feh --bg-fill ~/Pictures/wollpeper/chieh.jpg &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
conky &
xset r rate 200 50 &
dunst &
#picom &
fastcompmgr -r 20 -c -C -e 1.0 -i 1.0 -o 0.5 -m 0.3 -o 0.5 &
#fastcompmgr -o 0.4 -r 12 -c -C &
/usr/bin/kdeconnectd &
/usr/bin/kdeconnect-indicator &
clipcatd &
xss-lock -- sh -c "slock" &
#xautolock -time 10 -locker slock &
flameshot &
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
#mechvibes &
#/usr/libexec/pipewire-launcher &

emacs --daemon &

sh ~/.config/scripts/abodindwm/bar_dwm.sh &
chadwm
#while type chadwm >/dev/null; do chadwm && continue || break; done
