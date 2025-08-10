#!/bin/bash

# URL to check
URL="http://192.168.100.245/login.html"

# Timeout in seconds (adjust as needed)
TIMEOUT=10

# Notification settings
URGENCY="critical"  # can be "low", "normal", or "critical"
ICON="network-error"  # you can change this to another icon if you prefer

while true; do
    # Use curl to check the URL with a timeout
    if curl --max-time $TIMEOUT --connect-timeout $TIMEOUT --silent --output /dev/null "$URL"; then
        echo "$(date): Router interface is accessible"
    else
        echo "$(date): WARNING: Cannot access router interface!"
        notify-send -u "$URGENCY" -i "$ICON" "Router Connection Alert" "Cannot access router interface at $URL"
    fi
    
    # Wait 5 minutes before checking again
    sleep 300
done
