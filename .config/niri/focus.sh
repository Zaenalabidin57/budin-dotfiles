#!/bin/bash

# Get the output of the niri command
 output=$(niri msg focused-window)
#
 # Check if the command was successful (exit code 0)
if [[ $? -eq 0 ]]; then
# Use notify-send to display the output
notify-send "Niri Focused Window" "$output"
 else
   # Handle errors (e.g., niri not installed or command failed)
   notify-send "Niri Error" "Failed to get focused window information."
   -u critical
   fi
