bg=$(find ~/Pictures/MyGF/ -maxdepth 1 -type f | shuf -n 1)
cp $bg /tmp/image.jpg;
echo "/tmp/image.jpg";
