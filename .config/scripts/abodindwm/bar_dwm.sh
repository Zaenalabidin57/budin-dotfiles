#!/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0


# load colors
#. ~/.config/scripts/abodindwm/bar_themes/biji
#. ~/.config/scripts/abodindwm/bar_themes/catppuccin
. ~/.config/scripts/abodindwm/bar_themes/bored
#. ~/shigure/abodindwm/scripts/bar_themes/biji

temperature() {
  local temp_raw
  temp_raw=$(cat /sys/class/hwmon/hwmon1/temp1_input)
  local temp_deg="${temp_raw:0:2}"

  if [ $temp_deg -gt 80 ]; then
    printf "^c$black^ ^b$red^ $temp_deg°C"
  fi
#printf "^c$white^ ^b$grey^ $(cat /sys/class/hwmon/hwmon1/temp1_input)°C"  
}

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  cpu_speed=$(cat /proc/cpuinfo | grep 'cpu MHz' | awk '{printf("%.1f\n", $4 / 1000)}' | head -n 1)
  is_lagging=$(echo "$cpu_speed 0.5" | awk '{if ($1 < $2) print "true"; else print "false"}')
  if [ "$is_lagging" = true ]; then
    printf "^c$black^ ^b$red^ LAGtrain"
  fi
  #printf "^c$blue^ ^b$black^ CPU"
  printf "^c$white^ ^b$black^ CPU"
  printf "^c$white^ ^b$black^ $cpu_val"
}

pkg_updates() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$white^    Fully Updated"
  else
    printf "  ^c$white^    $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  if [ "$get_capacity" -eq 100 ]; then
    printf " "
  elif [ "$get_capacity" -lt 30 ]; then
    printf "^c$red^   $get_capacity CAS OEYYYY"
  else
    #printf "^c$blue^   $get_capacity"
    printf "^c$white^   $get_capacity"
  fi
}

brightness() {
  prostate=$(($(cat /sys/class/backlight/*/brightness) * 100 / 255))
  #printf "^c$blue^   "
  printf "^c$white^   "
  printf "^c$blue^%.0f\n" $prostate
}

mem() {
  #printf "^c$blue^^b$black^  "
  printf "^c$white^^b$black^  "
  printf "^c$white^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	#up) printf "^c$blue^ ^b$black^ 󰤨 ^d^%s" ;;
	up) printf "^c$white^ ^b$black^ 󰤨 ^d^%s" ;;
	down) printf "^c$black^ ^b$white^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	#printf "^c$blue^ ^b$black^ 󱑆 "
	printf "^c$white^ ^b$black^ 󱑆 "
	printf "^c$white^^b$black^ $(date '+%H:%M')  "
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

    #printf "^c$blue^ ^b$black^ 󰚫 ^d^%s"
    printf "^c$white^ ^b$black^ 󰚫 ^d^%s"
    if [ $rx_formatted -gt 1024 ]; then
      printf "^c$white^ ^b$black^ $(($rx_formatted / 1024 ))MB/s"
    else
    printf "^c$white^ ^b$black^ $rx_formatted KB/s"
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
sleep 1 && xsetroot -name "$(battery)$(temperature)$(network_speed)$(cpu) $(mem)$(wlan)$(clock)"
done
