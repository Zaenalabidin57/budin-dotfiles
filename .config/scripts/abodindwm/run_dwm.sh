#!/bin/sh

export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=xcb

xrdb merge ~/.Xresources &
xbacklight -set 10 &
xrandr --output HDMI-1 --left-of eDP-1
xrandr --output eDP --set TearFree on
nitrogen --restore
#feh --bg-fill ~/Pictures/wollpeper/saygex.jpg &
#feh --bg-fill ~/Pictures/wollpeper/chne.jpeg &
#feh --bg-fill ~/Pictures/wollpeper/chieh.jpg &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#conky &
xset r rate 200 50 &
dunst &
#picom &
#fastcompmgr -r 20 -c -C -e 1.0 -i 1.0 -o 0.5 -m 0.3 -o 0.5 &
fastcompmgr &
#fastcompmgr -o 0.4 -r 12 -c -C &
/usr/bin/kdeconnectd &
/usr/bin/kdeconnect-indicator &
#xss-lock -- sh -c "slock" &
xautolock -time 10 -locker slock &
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
#mechvibes &
#/usr/libexec/pipewire-launcher &
wayland-pipewire-idle-inhibit &
/usr/bin/pipewire &
/usr/bin/pipewire-pulse &
#restore-brightness &
libinput-gestures-setup start &
udisksctl mount -b /dev/disk/by-id/usb-JMicron_Generic_0123456789ABCDEF-0:0-part1 -t exfat /run/media/shigure/YEET &


clipcatd &

#yandex-disk start &


sh ~/.config/scripts/abodindwm/bar_dwm.sh &

/usr/bin/wireplumber &
dbus-run-session dwm
#while type chadwm >/dev/null; do dbus-run-session chadwm && continue || break; done
#while type dwm >/dev/null; do dbus-run-session dwm && continue || break; done
