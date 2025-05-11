#!/bin/dash

systemctl --user import-environment WAYLAND_DISPLAY
systemctl --user restart xdg-desktop-portal-wlr
systemctl --user restart xdg-desktop-portal
