#!/bin/bash

read -n1 -p "Do you want to use current directory, or ~/Music/OnTheSpot/? [c/m]" d;
echo "";
case $d in 
  c|C) echo "Using current dir" ;;
  m|M) echo "Using default music dir"; cd "$HOME/Music/OnTheSpot/" ;;
  *)   echo "No dir selected, exiting..." exit 1 ;;
esac


function convert() {
  NEW_TRACK_NAME=$(echo "$1" | sed s/\.ogg/\.mp3/g | sed s/\.~//g);
  ffmpeg -i "$1" -ar 44100 -ac 2 -b:a 160k "$NEW_TRACK_NAME";
}

export -f convert

#OGGS=$(find . -name '\.~*ogg');

#find . -type f -name '*ogg' -print0 | 
#  xargs -I@ -0 ffmpeg -i @ -ar 44100 -ac 2 -b:a 160k "$(echo @ | sed s/\.ogg/\.mp3/g | sed s/\.~//g)"

#exit 0;


find . -type f -name '*ogg' | while read song; do
  song=$(echo $song | sed 's/\"/\\\"/g');
  echo $song | sed 's/\"/\\\"/g';
  if [[ $song =~ "\"" ]]; then
    echo "Quotes"
    read -p "Correct?" cor;
    if [[ $cor == "n" ]]; then exit 1; fi;
    sleep 2;
  fi
  T_NEW_SONG=$(echo "$song" | sed s/\.~//g | sed s/\.ogg/\.mp3/g ); 
  if [ ! -f "$T_NEW_SONG" ]; then 
    read -n1 -p "Would you like to convert them to mp3? [Y/n]" c;
    echo "";
    case $c in 
      y|Y) convert "$song" ;;
      n|N) echo "Skipping..." ;;
      *) find . -name '\.~*ogg' -exec bash -c "convert \"{}\"" \; ;;
    esac;
  fi;
done

read -n1 -p "Are you done?" done;

