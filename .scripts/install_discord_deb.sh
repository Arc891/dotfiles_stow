#!/bin/bash
cd $HOME/Downloads;

DISCORD=$(find . -maxdepth 1 -type f -name 'discord-*\.deb');

sudo apt install $DISCORD;

mv $DISCORD -t Apps/;
