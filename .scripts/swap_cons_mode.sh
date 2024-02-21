#!/usr/bin/env bash
HOME_FOLDER="$1"
MODE=`cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode`

if [[ ! -d $HOME_FOLDER]]; then
	echo "No home folder found"
	exit 1
fi

if [[ $MODE -eq 1 ]]
then
	. $1/.dotfiles/scripts/conservation_mode.sh off

elif [[ $MODE -eq 0 ]]
then
	. $1/.dotfiles/scripts/conservation_mode.sh on

else 
	echo "Something went really wrong, cons_mode did not equal 0 or 1"
fi

