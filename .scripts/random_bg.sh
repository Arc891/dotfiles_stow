bg=$(find ~/Pictures/Backgrounds/ -maxdepth 1 -type f | shuf -n 1)

swww query || swww init
swww img $bg --transition-fps 60 --transition-type wipe --transition-duration 2
