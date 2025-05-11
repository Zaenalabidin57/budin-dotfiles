#!/bin/sh -e

out="$HOME/Pictures/Screenshots/$(date +%Y/%Y%m%d_%H%M%S).png"

while getopts o:s arg; do case $arg in
    o) out="$OPTARG" ;;
    s) sel="$(slurp -o)" ;;
    ?|*) echo "usage: ${0##*/} [-s] [-o out]" >&2; exit 1 ;;
esac; done

grim ${sel:+ -g "$sel"} "$out"
echo "$out"
printf 'file://%s' "$out" | wl-copy -t text/uri-list
