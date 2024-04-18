bg=$(find ~/Pictures/Backgrounds/ -maxdepth 1 -type f | shuf -n 1)

export SWWW_TRANSITION="random";

swww query || swww init
swww img $bg --transition-type random
