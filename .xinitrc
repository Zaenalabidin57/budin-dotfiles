#!/bin/sh
export XDG_SESSION_TYPE=x11
xset r rate 200 50
exec ~/.config/scripts/abodindwm/run_dwm.sh
#exec dbus-run-session icewm-session
#exec dbus-run-session jwm
#exec ~/.config/scripts/abodinrwm/run_rwm.sh
#exec dbus-run-session rwm
#exec ~/shigure/dinfwm/autostart.sh
#exec chadwm
#exec dbus-run-session openbox
#exec dbus-run-session i3
#exec ~/.config/scripts/sxwm/run_sxwm.sh
#exec dbus-run-session chadwm
#exec sxwm
#exec awesome
