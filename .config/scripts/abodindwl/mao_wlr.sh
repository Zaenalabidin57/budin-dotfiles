#!/bin/sh

systemctl --user import-environment WAYLAND_DISPLAY
systemctl --user restart xdg-desktop-portal-wlr
systemctl --user restart xdg-desktop-portal
/usr/lib/xdg-desktop-portal -r &
