#!/bin/sh

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
  cpu_speed=$(cat /proc/cpuinfo | grep 'cpu MHz' | awk '{printf("%.1f\n", $4 / 1000)}' | head -n 1)
  is_lagging=$(echo "$cpu_speed 0.5" | awk '{if ($1 < $2) print "true"; else print "false"}')
  if [ "$is_lagging" = true ]; then
    printf "^c$black^ ^b$red^ LAGtrain"
  fi

  printf "$cpu_speed"
  #printf "^c$green^ ^b$black^ CPU"
  #printf "^c$green^ ^b$grey^ $cpu_val"
}

while true; do
sleep 1 && echo $(cpu)
done
