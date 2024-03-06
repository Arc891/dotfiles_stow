start_threshold=$(cat /sys/class/power_supply/BAT0/charge_start_threshold)
stop_threshold=$(cat /sys/class/power_supply/BAT0/charge_stop_threshold)

echo "$start_threshold->$stop_threshold"
