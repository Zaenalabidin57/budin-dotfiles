#!/bin/sh

# Get the current width and height
current_width=$(waydroid prop get persist.waydroid.width)
current_height=$(waydroid prop get persist.waydroid.height)

# Define mobile and tablet resolutions
mobile_width=441
mobile_height=1019
tablet_width=1920
tablet_height=1019

# Function to set the resolution and restart Waydroid
set_resolution() {
  waydroid prop set persist.waydroid.width "$1"
  waydroid prop set persist.waydroid.height "$2"
  echo "Setting resolution to ${1}x${2}"
  sudo systemctl restart waydroid-container
}

# Check if the current resolution is mobile
if [ "$current_width" = "$mobile_width" ] && [ "$current_height" = "$mobile_height" ]; then
  echo "Current resolution is Mobile. Switching to Tablet."
  set_resolution "$tablet_width" "$tablet_height"
# Check if the current resolution is tablet
elif [ "$current_width" = "$tablet_width" ] && [ "$current_height" = "$tablet_height" ]; then
  echo "Current resolution is Tablet. Switching to Mobile."
  set_resolution "$mobile_width" "$mobile_height"
else
  # Handle the case where the resolution is neither mobile nor tablet (e.g., first run)
  echo "Unknown resolution. Setting to Mobile."
  set_resolution "$mobile_width" "$mobile_height"
fi
