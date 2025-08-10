#!/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
#. ~/.config/chadwm/scripts/bar_themes/dracula

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  cpu_speed=$(cat /proc/cpuinfo | grep 'cpu MHz' | awk '{printf("%.1f\n", $4 / 1000)}' | head -n 1)
  is_lagging=$(echo "$cpu_speed 0.5" | awk '{if ($1 < $2) print "true"; else print "false"}')
  if [ "$is_lagging" = true ]; then
    printf "LAGtrain"
  fi
  printf "CPU "
  printf "$cpu_val"
}


battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  if [ "$get_capacity" -eq 100 ]; then
    printf ""
  elif [ "$get_capacity" -lt 30 ]; then
    printf "  $get_capacity CAS OEYYYY"
  else
    printf "  $get_capacity"
  fi
}

brightness() {
  # Get the current brightness value.
  current_brightness=$(cat /sys/class/backlight/*/brightness)

  # Get the maximum possible brightness value.
  max_brightness=$(cat /sys/class/backlight/*/max_brightness)

  # Calculate the percentage.
  # We use 'bc' for floating-point arithmetic to get a more precise percentage
  # before rounding it to the nearest integer with printf.
  percentage=$(bc <<< "scale=2; ($current_brightness / $max_brightness) * 100")

  # Print the brightness icon and the calculated percentage.
  printf " %.0f%%\n" "$percentage"
}

mem() {
  printf "  "
  printf " $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	#up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	up) printf " 󰤨 ";;
	down) printf " 󰤭 " " Disconnected" ;;
	esac
}

temperature() {
  local temp_raw
  temp_raw=$(cat /sys/class/hwmon/hwmon1/temp1_input)
  local temp_deg="${temp_raw:0:2}"

  if [ $temp_deg -gt 80 ]; then
    printf " $temp_deg°C"
  else
    printf ""
  fi
#printf "^c$white^ ^b$grey^ $(cat /sys/class/hwmon/hwmon1/temp1_input)°C"  
}

clock() {
	printf " 󱑆 "
	printf " $(date '+%H:%M')  "
}

network_speed() {
    local rx_delta
    local tx_delta

    # Call update for RX bytes. The glob expands to matching interface statistics files.
    # If the glob matches no files, `update` handles it gracefully (sum becomes 0).
    # shellcheck disable=SC2046 # We need word splitting for the glob passed to update
    rx_delta=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
    # shellcheck disable=SC2046
    tx_delta=$(update /sys/class/net/[ew]*/statistics/tx_bytes)

    # Ensure rx_delta and tx_delta are non-negative integers (defensive)
    rx_delta=${rx_delta:-0} && [[ "$rx_delta" =~ ^[0-9]+$ ]] || rx_delta=0
    tx_delta=${tx_delta:-0} && [[ "$tx_delta" =~ ^[0-9]+$ ]] || tx_delta=0
    # `update` should already ensure diff is not negative, but an extra check here is fine.
    # if [ "$rx_delta" -lt 0 ]; then rx_delta=0; fi
    # if [ "$tx_delta" -lt 0 ]; then tx_delta=0; fi


    local rx_formatted
    local tx_formatted

    rx_formatted="$(($rx_delta / 1024))"
    tx_formatted="$tx_delta"

    printf " 󰚫 "
    if [ $rx_formatted -gt 1024 ]; then
      printf "$(($rx_formatted / 1024 ))MB/s"
    else
    printf "$rx_formatted KB/s"
    fi

    # Format the output string for the status bar
    # %4s pads the string with spaces to a width of 4 if it's shorter.
    # 'B' is appended after the (potentially padded) formatted number.
}

update() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$(( sum + i ))
    done
    cache=/tmp/${1##*/}
    [ -f "$cache" ] && read -r old < "$cache" || old=0
    printf %d\\n "$sum" > "$cache"
    printf %d\\n $(( sum - old ))
}

while true; do

  sleep 1 && xsetroot -name "$(network_speed)$(temperature) $(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done
