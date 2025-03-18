#!/bin/bash

DIR="$HOME/.config/my_device"
PUBLIC_IP="$(cat $DIR/pub_ip.txt)"
PORT="$(cat $DIR/pi_port.txt)"
NAME="$(cat $DIR/name.txt)"
STATUS_FILE="$DIR/status_$NAME.txt";
STATUS="$(cat $STATUS_FILE)"

timeout 5 nc -zv $PUBLIC_IP $PORT > /dev/null 2>&1;

if [ $? -ne 0 ]; then
  if [[ $STATUS == "On" ]]; then
    notify-send "Device Status" "$NAME has gone offline.";
    echo "Off" > $STATUS_FILE;
  fi
  echo "Device is offline.";
else
  if [[ $STATUS == "Off" ]]; then
    notify-send "Device Status" "$NAME is back online!";
    echo "On" > $STATUS_FILE;
  fi
  echo "Device is online!";
fi

