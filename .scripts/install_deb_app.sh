#!/bin/bash
cd $HOME/Downloads;
echo "Enter app to install: ";
read app_name;

APP=$(find . -maxdepth 1 -type f -iname "*$app_name*\.deb");

if [ -z $APP ]; then
  echo "Package '$app_name' not found."
  exit 1;
fi

sudo apt install $APP;

if [ $? -eq 0 ]; then
  mv $APP -t Apps/;
else
  echo "Installation cancelled.";
fi
