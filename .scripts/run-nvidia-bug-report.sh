#!/bin/bash

#if [ $(id -u) -ne 0 ]; then
#  echo "Please run as root.";
#  exit
#fi 

sudo nvidia-bug-report.sh

mv "/home/ezrah/nvidia-bug-report.log.gz" "/home/ezrah/nvidia-logs/nvidia-bug-report-$(date +%d-%m-%Y-%H:%M).log.gz"
