swayidle -w \
	timeout 300 'swaylock -f -c 000000' \
	timeout 1000 'systemctl hibernate' \
	timeout 600 'wlopm --off \*' \
	resume 'wlopm --on \*' \
	before-sleep 'swaylock -f -c 000000' >/dev/null 2>&1 &
