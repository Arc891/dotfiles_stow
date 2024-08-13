#!/bin/bash

# Replace with your public IP address and the specific port
PUBLIC_IP="$(cat $HOME/.config/pub_ip.txt)"
PORT="$(cat $HOME/.config/pi_port.txt)"

# Check if the port is open
nc -zv $PUBLIC_IP $PORT > /dev/null 2>&1

# Check the result
if [ $? -ne 0 ]; then
  notify-send "Device Status" "Device is offline"
else 
  echo "Device is online!"
fi

