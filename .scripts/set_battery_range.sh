bat_dir="/sys/class/power_supply/BAT0/"
echo "Current charge: $(cat $bat_dir/charge_start_threshold) -> $(cat $bat_dir/charge_stop_threshold)";
read -p "Start charging below: " b;
read -p "Stop charging above: " a;
echo $b | sudo tee /sys/class/power_supply/BAT0/charge_start_threshold;
echo $a | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold;
