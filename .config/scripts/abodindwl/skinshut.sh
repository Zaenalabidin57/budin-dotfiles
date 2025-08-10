#!/bin/bash

# Define the screenshot directory
screenshot_dir="$HOME/Pictures/Screenshots"


# Generate a timestamp for the filename
timestamp=$(date +%Y%m%d_%H%M%S)

# Define the filename
filename="screenshot_$timestamp.png"
filepath="$screenshot_dir/$filename"

area=$(slurp)
if [ -n "$area" ]; then
  grim -g "$area" "$filepath"
  grim -g "$area" - | wl-copy --type image/png
  notify-send "Skrinsutto di seve di ${filepath}/${filename}"
fi
