cd /etc/nixos/

git status
git diff

read -p 'Do you want to add all? [Y/n] ' add_all;
if [[ $add_all == 'N' ]] || [[ $add_all == 'n' ]]; then
	exit 1;
fi
git add .

git status

read -p 'Commit message: ' msg;
git commit -m "$msg";
git push

read -p 'Option to rebuild: ' rebuild_opt;
nixos-rebuild $rebuild_opt
