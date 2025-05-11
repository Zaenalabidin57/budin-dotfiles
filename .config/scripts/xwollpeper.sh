#!/bin/bash

# Configuration
WALLPAPER_DIR="/home/shigure/wollpeper/dolls/white_dolls" # Replace with your wallpaper directory
LAST_USED_FILE="$HOME/.wallpaper_last_used"
INTERVAL=300 # 5 minutes in seconds

# Function to get a random image, excluding the last used
get_random_image() {
  local images=($(find "$WALLPAPER_DIR" -type f -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png"))
  local image_count=${#images[@]}

  if [ $image_count -eq 0 ]; then
    echo "No images found in $WALLPAPER_DIR"
    return 1
  fi

  local last_used=$(cat "$LAST_USED_FILE" 2>/dev/null)

  if [ -n "$last_used" ]; then
    local filtered_images=()
    for image in "${images[@]}"; do
      if [[ "$image" != "$last_used" ]]; then
        filtered_images+=("$image")
      fi
    done
    images=("${filtered_images[@]}")
    image_count=${#images[@]}
    if [ $image_count -eq 0 ]; then
        echo "All images have been used, restarting the cycle"
        images=($(find "$WALLPAPER_DIR" -type f -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png"))
        image_count=${#images[@]}
    fi

  fi

  local random_index=$((RANDOM % image_count))
  echo "${images[$random_index]}"
}

# Function to set the wallpaper
set_wallpaper() {
  local image="$1"

  if [ -n "$image" ] && [ -f "$image" ]; then
    feh --bg-fill "$image"
    echo "$image" > "$LAST_USED_FILE"
    echo "Wallpaper set to: $image"
  else
    echo "Invalid image path: $image"
  fi
}

# Main loop
while true; do
  random_image=$(get_random_image)
  if [ $? -eq 0 ]; then
      set_wallpaper "$random_image"
  fi

  sleep "$INTERVAL"
done
