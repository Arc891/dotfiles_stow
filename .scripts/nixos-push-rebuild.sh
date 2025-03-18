#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "You must be root to do this." 1>&2
    exit 100
fi
cd /etc/nixos/

git status
git diff

read -p 'Do you want to add all? [Y/n] ' add_all;
if [[ $add_all == 'N' ]] || [[ $add_all == 'n' ]]; then
	exit 1;
fi
git add .
git add *

nixos-rebuild dry-activate

git status

read -p 'Commit message: ' msg;
git commit -m "$msg";
git push

read -p 'Option to rebuild (switch by default): ' rebuild_opt;
if [[ -z "$rebuild_opt" ]]; then
	rebuild_opt="switch";
fi	
nixos-rebuild $rebuild_opt
