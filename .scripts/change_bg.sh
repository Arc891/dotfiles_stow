swww query || swww init

while true; do
  find ~/Pictures/Backgrounds/ -maxdepth 1 -type f -print0 |
    sort --zero-terminated --random-sort |
    while IFS= read -r -d '' bg; do 
      echo $bg;
      swww img $bg --transition-fps 60 --transition-type wipe --transition-duration 2
      sleep 300;
    done;
done;

#ln -sf $bg /usr/share/sddm/themes/sdt/wallpaper.jpg
