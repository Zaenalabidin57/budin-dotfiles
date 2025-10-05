swayidle -w \
  timeout 300 'swaylock ' \
	timeout 600 'wlopm --off \*' \
	timeout 1000 'systemctl hibernate' \
	resume 'wlopm --on \*' \
  before-sleep 'swaylock '

