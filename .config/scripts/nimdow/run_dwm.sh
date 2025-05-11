#!/bin/sh

xrdb merge ~/.Xresources &
xbacklight -set 10 &
#xrandr --output HDMI-1 --left-of eDP-1
xrandr --output HDMI-1 --right-of eDP-1
xrandr --output eDP-1 --set TearFree on
xrandr --output HDMI-1 --set TearFree on
nitrogen --restore
#feh --bg-fill ~/Pictures/wollpeper/chne.jpeg &
#feh --bg-fill ~/Pictures/wollpeper/chieh.jpg &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xset r rate 200 50 &
dunst &
#picom &
fastcompmgr &
#fastcompmgr -o 0.4 -r 12 -c -C &
/usr/bin/kdeconnectd &
/usr/bin/kdeconnect-indicator &
clipcatd &
xss-lock -- sh -c "i3lock-fancy-dualmonitor -p" &
flameshot &

dash ~/.config/scripts/abodindwm/bar_dwm.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
