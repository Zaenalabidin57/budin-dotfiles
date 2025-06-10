# Ensure these are initialized at the VERY TOP of your bar_dwm.sh script,
# outside any functions or loops:
# _network_last_rx_bytes=""
# _network_last_time_s="" # Or _network_last_time_ns if you prefer nanosecond precision (needs GNU date)

# Give the state variables more unique names to avoid collision:
_ns_last_rx_bytes=""
_ns_last_time_s=""
# And update network_interface definition if it's not already there
 network_interface="wlan0" # or your actual interface

network_speed() {
    # Use the more unique names internally too
    echo "DEBUG NS: Top: _ns_last_rx=[$_ns_last_rx_bytes], _ns_last_time=[$_ns_last_time_s]" # DEBUG

    current_rx_bytes=$(awk -v iface="$network_interface:" '$1 == iface {print $2}' /proc/net/dev)
    current_time_s=$(date +%s) # Using seconds for simplicity and POSIX sh

    echo "DEBUG NS: Current vals: current_rx=[$current_rx_bytes], current_time=[$current_time_s]" # DEBUG

    if [ -z "$current_rx_bytes" ]; then
        # Reset unique state variables
        _ns_last_rx_bytes=""
        _ns_last_time_s=""
        # Ensure $red and $grey are defined with your actual color codes
        printf "^c%s^ ^b%s^ %s ERR " "$red" "$grey" "$network_interface"
        return 1
    fi

    if [ -z "$_ns_last_rx_bytes" ] || [ -z "$_ns_last_time_s" ]; then
        echo "DEBUG NS: CALC block. Assigning to _ns_last_ vars." # DEBUG
        _ns_last_rx_bytes=$current_rx_bytes
        _ns_last_time_s=$current_time_s
        echo "DEBUG NS: CALC - After assign: _ns_last_rx=[$_ns_last_rx_bytes], _ns_last_time=[$_ns_last_time_s]" # DEBUG
        # Ensure $white and $grey are defined
        printf "^c%s^ ^b%s^ ↓CALC KiB/s " "$white" "$grey"
        return 0
    fi

    # --- Calculations for speed (should be reached after first 'CALC') ---
    rx_diff=$(($current_rx_bytes - $_ns_last_rx_bytes))
    time_diff_s=$(($current_time_s - $_ns_last_time_s))

    echo "DEBUG NS: Diffs: rx_diff=[$rx_diff], time_diff_s=[$time_diff_s]" # DEBUG

    # Update state for the NEXT call (with unique names)
    _ns_last_rx_bytes=$current_rx_bytes
    _ns_last_time_s=$current_time_s

    local speed_kibps="0.00" # Use local for vars only needed inside this calculation scope

    if [ "$rx_diff" -lt 0 ] || [ "$time_diff_s" -le 0 ]; then
        speed_kibps="0.00"
        echo "DEBUG NS: Bad diffs, speed forced to 0.00" # DEBUG
    else
        # bc is POSIX. Ensure it's installed.
        speed_kibps=$(echo "scale=2; $rx_diff / ($time_diff_s * 1024)" | bc)
        echo "DEBUG NS: Calculated speed_kibps=[$speed_kibps] by bc" # DEBUG
    fi

    if [ -z "$speed_kibps" ]; then # Fallback if bc failed
        speed_kibps="0.00"
        echo "DEBUG NS: bc output was empty, speed forced to 0.00" # DEBUG
    fi

    local formatted_speed_kibps # Use local
    formatted_speed_kibps=$(printf "%.2f" "$speed_kibps")

    echo "DEBUG NS: Final output: ↓$formatted_speed_kibps KiB/s" # DEBUG
    # Ensure $green and $black are defined
    printf "^c%s^ ^b%s^ ↓%s KiB/s " "$green" "$black" "$formatted_speed_kibps"
    return 0
}

while true; do
 sleep 1 && echo $(network_speed)
done
