#!/bin/bash

readarray -t window_ids < <(niri msg -j windows | jq -r '.[].id')
readarray -t window_title < <(niri msg -j windows | jq -r '.[].title')


selected_title=$(printf "%s\n" "${window_title[@]}" | fuzzel --dmenu )

for i in "${!window_title[@]}"; do
  if [[ "${window_title[$i]}" == "$selected_title" ]]; then
    selected_id=${window_ids[$i]}
  fi
done


niri msg action focus-window --id $selected_id


