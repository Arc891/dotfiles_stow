bat=$(polychromatic-cli -k | grep Battery | tr -dc '0-9')
if [[ $bat == "0" ]]; then 
  echo "-";
else
  echo $bat;
fi
