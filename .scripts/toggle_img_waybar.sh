conf_file="/home/anamata/.config/waybar/config.jsonc";

if [[ ! -z $(grep pics $conf_file | grep '//') ]]; then
  echo "Toggle comment off";
  sed -i '18s/\// /g' $conf_file;
else 
  echo "Toggle comment on";
  sed -i '18s/ /\//g' $conf_file;
fi
