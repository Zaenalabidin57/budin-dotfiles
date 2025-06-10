#!/usr/bin/fish

# Fish shell version of the status bar script

# ^c$var^ = fg color (dwm color patch specific, remains as is for xsetroot)
# ^b$var^ = bg color (dwm color patch specific, remains as is for xsetroot)

set -g interval 0 # Use 'set -g' for global scope if needed, or 'set -l' in functions for local

# load colors
# Ensure the path is correct and the sourced script is fish-compatible or only sets variables
# If 'biji' only contains variable assignments like 'var=value', it might need conversion to 'set var value'
# or be sourced carefully. For this conversion, we assume it sets environment variables or fish variables correctly.
source ~/.config/scripts/abodindwm/bar_themes/biji.fish
# source ~/shigure/abodindwm/scripts/bar_themes/biji

# --- Temperature ---
function temperature
    set -l temp_raw (cat /sys/class/hwmon/hwmon1/temp1_input)
    # Fish string manipulation: string sub -s <start_index> -l <length> <string>
    # Bash: ${temp_raw:0:2} (first 2 chars) -> Fish: string sub -l 2 "$temp_raw" (length 2 from start)
    # Note: fish string indices are 1-based for -s, but -l from start is simpler here.
    set -l temp_deg (string sub -l 2 "$temp_raw")

    # Fish conditional: if <condition>; ...; else if <condition>; ...; else; ...; end
    # Arithmetic comparison: use `test` or `math`
    if test "$temp_deg" -gt 80
        printf "^c%s^ ^b%s^ %s°C" "$grey" "$red" "$temp_deg"
    else
        printf "" # Or nothing if you want no output
    end
    # printf "^c%s^ ^b%s^ %s°C" "$white" "$grey" (cat /sys/class/hwmon/hwmon1/temp1_input)
end

# --- CPU ---
function cpu
    # Command substitution is the same: (command)
    set -l cpu_val (string split " " (cat /proc/loadavg))[1] # Get first field

    # Fish doesn't have direct awk in-line math like bash's $() with awk.
    # We can use `math` for arithmetic.
    set -l cpu_mhz_raw (cat /proc/cpuinfo | grep 'cpu MHz' | string match -r ':\s*([0-9.]+)' | string split -m1 .)[1] # Extract number before decimal
    if test -n "$cpu_mhz_raw" # Check if cpu_mhz_raw is not empty
      set -l cpu_speed (math "$cpu_mhz_raw / 1000")
      set -l is_lagging (test (math --scale=1 "$cpu_speed < 0.5") -eq 1; and echo true; or echo false)

      if string match -q -- "true" "$is_lagging"
          printf "^c%s^ ^b%s^ LAGtrain" "$black" "$red"
      end
    end
    printf "^c%s^ ^b%s^ CPU" "$green" "$black"
    printf "^c%s^ ^b%s^ %s" "$green" "$grey" "$cpu_val"
end

# --- Package Updates ---
function pkg_updates
    # Command substitution and pipes work similarly.
    # 'timeout' is an external command, should work if installed.
    # 'checkupdates' is specific to Arch. 'xbps-install' to Void, 'aptitude' to Debian/Ubuntu.
    # Using 'checkupdates' as per the original uncommented line.
    # Fish counts lines from command output: (command | wc -l)
    set -l updates (timeout 20 checkupdates 2>/dev/null; or true | wc -l | string trim)

    # Fish string check: `test -z "$string"` or `string length -q -- "$string"`
    if test -z "$updates" -o "$updates" = "0" # checkupdates might output 0 lines or an empty string if no updates
        printf "  ^c%s^    Fully Updated" "$green"
    else
        # Ensure updates is a number before printing, or handle cases where it might not be.
        # The original script assumed `wc -l` output is directly usable.
        printf "  ^c%s^    %s updates" "$green" "$updates"
    end
end

# --- Battery ---
function battery
    if test -e /sys/class/power_supply/BAT0/capacity # Check if file exists
        set -l get_capacity (string trim (cat /sys/class/power_supply/BAT0/capacity))
        if test "$get_capacity" = "100"
            printf " "
        else if test "$get_capacity" -lt 30
            printf "^c%s^   %s CAS OEYYYY" "$red" "$get_capacity"
        else
            printf "^c%s^   %s" "$blue" "$get_capacity"
        end
    else
        printf "" # No battery info
    end
end

# --- Brightness ---
function brightness
    # Bash arithmetic: $((...)) -> Fish math: (math "...")
    # Globbing * should work if unambiguous, otherwise specify path more directly if needed.
    set -l brightness_file (ls /sys/class/backlight/*/brightness | head -n 1)
    if test -n "$brightness_file" -a -e "$brightness_file"
        set -l prostate (math (cat "$brightness_file") \* 100 / 255)
        printf "^c%s^   " "$blue"
        printf "^c%s^%.0f\n" "$blue" "$prostate"
    else
        printf "" # No brightness info
    end
end

# --- Memory ---
function mem
    printf "^c%s^^b%s^  " "$blue" "$black"
    # awk and sed are external commands, usage remains the same.
    printf "^c%s^ %s" "$blue" (free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
end

# --- WLAN ---
function wlan
    # Fish switch statement: switch <value>; case <pattern>; ...; case '*'; ...; end
    # Reading file content directly into switch. Ensure path is correct.
    # The glob wl* might need to be more specific if multiple interfaces exist, e.g., (ls /sys/class/net/wl*/operstate | head -n 1)
    set -l operstate_file (ls /sys/class/net/wl*/operstate 2>/dev/null | head -n 1)
    if test -n "$operstate_file" -a -e "$operstate_file"
        switch (cat "$operstate_file" | string trim)
            case up
                printf "^c%s^ ^b%s^ 󰤨 ^d^" "$blue" "$black" # Removed %s from original as it was empty
            case down
                printf "^c%s^ ^b%s^ 󰤭 ^d^^c%s^Disconnected" "$black" "$blue" "$blue"
            case '*' # Default case for any other state
                printf "^c%s^ ^b%s^ question ^d^" "$grey" "$black" # Example for unknown state
        end
    else
        printf "^c%s^ ^b%s^ No Wifi ^d^" "$grey" "$black" # No wifi interface found
    end
end

# --- Clock ---
function clock
    printf "^c%s^ ^b%s^ 󱑆 " "$blue" "$black"
    # 'date' command is external, usage remains the same.
    printf "^c%s^^b%s^ %s  " "$green" "$black" (date '+%H:%M')
end

# --- Network Speed ---
# The 'update' helper function needs to be defined in fish syntax.
# Global variables for previous values if not using temp files.
set -g __prev_rx_bytes 0
set -g __prev_tx_bytes 0
set -g __last_update_time (date +%s)

function network_speed_fish
    set -l current_time (date +%s)
    set -l time_delta (math $current_time - $__last_update_time)

    # Avoid division by zero if script runs too fast or first run
    if test $time_delta -eq 0
        set time_delta 1
    end

    set -l current_rx_bytes 0
    set -l current_tx_bytes 0

    # Summing up bytes from all relevant interfaces
    for interface_stat_rx in /sys/class/net/[ew]*/statistics/rx_bytes
        if test -e $interface_stat_rx
            set current_rx_bytes (math $current_rx_bytes + (cat $interface_stat_rx))
        end
    end
    for interface_stat_tx in /sys/class/net/[ew]*/statistics/tx_bytes
        if test -e $interface_stat_tx
            set current_tx_bytes (math $current_tx_bytes + (cat $interface_stat_tx))
        end
    end

    set -l rx_delta_bytes (math $current_rx_bytes - $__prev_rx_bytes)
    set -l tx_delta_bytes (math $current_tx_bytes - $__prev_tx_bytes)

    # Update global previous values for next call
    set -g __prev_rx_bytes $current_rx_bytes
    set -g __prev_tx_bytes $current_tx_bytes
    set -g __last_update_time $current_time

    # Calculate speed in KB/s or MB/s
    set -l rx_speed_kbps (math --scale=2 "$rx_delta_bytes / $time_delta / 1024")
    set -l tx_speed_kbps (math --scale=2 "$tx_delta_bytes / $time_delta / 1024") # Added TX speed calculation

    printf "^c%s^ ^b%s^ 󰚫 RX " "$darkblue" "$black" # Using a known color variable, ensure $darkblue is set
    if math "$rx_speed_kbps > 1024"
        printf "^c%s^ ^b%s^ %.1fMB/s" "$green" "$grey" (math --scale=1 "$rx_speed_kbps / 1024")
    else
        printf "^c%s^ ^b%s^ %.0fKB/s" "$green" "$grey" "$rx_speed_kbps"
    end

    # Optionally, print TX speed as well
    # printf " TX "
    # if math "$tx_speed_kbps > 1024"
    #     printf "^c%s^ ^b%s^ %.1fMB/s" "$cyan" "$grey" (math --scale=1 "$tx_speed_kbps / 1024")
    # else
    #     printf "^c%s^ ^b%s^ %.0fKB/s" "$cyan" "$grey" "$tx_speed_kbps"
    # end
end


# The original 'update' function logic is complex for direct fish translation
# without deeper understanding of its usage with `network_speed`.
# The bash version uses temp files for caching previous values for each interface.
# A simpler fish version for network speed might calculate total and diff without per-file caching,
# or use fish's global variables if the script runs persistently.
# For now, I'll provide a conceptual fish `network_speed` that doesn't rely on the exact `update` logic
# but calculates total speed. If precise per-interface caching is needed, the `update` function
# would need a more careful fish implementation using associative arrays or multiple global vars.

# The original `update` function:
# update() {
#   sum=0
#   for arg; do
#     read -r i < "$arg"
#     sum=$(( sum + i ))
#   done
#   cache=/tmp/${1##*/} # Basename of the first argument
#   [ -f "$cache" ] && read -r old < "$cache" || old=0
#   printf %d\\n "$sum" > "$cache"
#   printf %d\\n $(( sum - old ))
# }
# This function seems to be designed to be called like:
# rx_delta=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
# It sums current values, stores sum, and returns diff from previous sum for the *first file path's basename*.
# This is tricky because the cache key is based on the first file in the glob.
# The `network_speed_fish` function above is a more direct way to get total speed.

# --- Main Loop ---
while true
    # The original script had pkg_updates commented out in the loop.
    # If you want to run it periodically:
    # if test $interval -eq 0 -o (math "$interval % 3600") -eq 0
    #   set updates_output (pkg_updates) # Capture output if needed elsewhere
    # else
    #   set updates_output "" # Or keep previous if not updated
    # end
    # set -g interval (math $interval + 1)

    # Assemble the status string
    # Ensure all functions are defined and variables (like colors) are available.
    set -l status_string ""
    set -a status_string (network_speed_fish) # Use the fish version
    set -a status_string (temperature)
    set -a status_string (battery)
    set -a status_string (cpu)
    set -a status_string (mem)
    set -a status_string (wlan)
    set -a status_string (clock)
    # set -a status_string $updates_output # If using periodic updates

    # xsetroot is an external command
    sleep 1; and echo -name (string join " " $status_string)
end

