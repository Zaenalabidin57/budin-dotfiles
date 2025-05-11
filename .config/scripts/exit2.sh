#!/bin/bash

# Function to display a dialog menu and handle user selection
show_menu() {
  local choices=(
    "Reboot" "r"
    "Poweroff" "p"
    "Hibernate" "h"
    "Shutdown" "s"
    "Logout" "L"
  )

  local choice=$(dialog --stdout --menu "Pilih Sistem:" 15 40 5 "${choices[@]}")

  case "$choice" in
    "r")
      sudo reboot
      ;;
    "p")
      swaylock
      ;;
    "h")
      systemctl hibernate
      ;;
    "s")
      notify-send "Sistem akan mati dalam 5 detik"
      echo "shutting down in 5 seconds"
      sudo shutdown -h now
      mpv --screen=1 --fs --fs-screen=1 ~/.config/scripts/media/shutdown.webm
      ;;
    "L")
      notify-send "Sistem keluar"
      sudo udisksctl unmount -b /dev/sdb1
      sudo udisksctl power-off -b /dev/sdb
      sudo udisksctl unmount -b /dev/sda1
      sudo udisksctl power-off -b /dev/sda
      cliphist wipe
      sudo logout
      ;;
    "")
      # User canceled
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
}

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
  echo "dialog is not installed. Please install it."
  exit 1
fi

# Run the menu
show_menu
