#!/bin/bash

bat=$(razer-cli --battery print | grep charge | awk -F' ' '{print $2}')
if [[ $bat == "0" ]]; then 
  echo "-";
else
  echo $bat;
fi
