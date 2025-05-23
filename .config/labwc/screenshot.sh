#!/bin/bash

# Define the screenshot directory
screenshot_dir="$HOME/Pictures/screenshots"

# Ensure the directory exists
mkdir -p "$screenshot_dir"

# Generate a timestamp for the filename
timestamp=$(date +%Y%m%d_%H%M%S)

# Define the filename
filename="screenshot_$timestamp.png"
filepath="$screenshot_dir/$filename"

area=$(slurp)

# Take the screenshot using grim and select the region with slurp
grim -g "$area" "$filepath"
grim -g "$area" - | wl-copy

if [ $? -eq 0 ]; then
  # Copy the filepath to the clipboard using wl-copy (you might need to install this)
  if command -v wl-copy &> /dev/null; then
    echo "$filepath" | wl-copy
    notify-send "Screenshot saved to ~/Pictures/screenshots/ and path copied to clipboard."
  elif command -v xclip &> /dev/null; then
    echo "$filepath" | xclip -selection clipboard
    notify-send "Screenshot saved to ~/Pictures/screenshots/ and path copied to clipboard (using xclip)."
  else
    notify-send "Screenshot saved to ~/Pictures/screenshots/. Could not copy path to clipboard (wl-copy or xclip not found)."
  fi
else
  notify-send "Error: Failed to take screenshot."
fi

exit 0
