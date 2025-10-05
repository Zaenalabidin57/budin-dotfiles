#systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
#dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
dunst &
swaybg -i ~/Pictures/alice.jpg -m fill &
wl-paste --watch cliphist store &
bash ~/.config/scripts/abodindwl/turu.sh &
bash ~/.config/scripts/abodindwl/wlranjeng.sh &
gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
waybar -c /home/shigure/.config/waybar/config_mao &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xdg-desktop-portal -r &
/usr/lib/xdg-desktop-portal-wlr -r &
kdeconnectd &
kdeconnect-indicator &
wayland-pipewire-idle-inhibit &
foot -s &
kanshi &
udisksctl mount -b /dev/disk/by-id/usb-JMicron_Generic_0123456789ABCDEF-0:0-part1 -t exfat /run/media/shigure/YEET &
