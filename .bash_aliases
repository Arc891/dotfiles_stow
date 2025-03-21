#------# VARIABLES #------#

CODING="$HOME/Coding"
CONFIG="$HOME/.config"
ASCII="$CONFIG/ascii"
DOTFILES="$HOME/.dotfiles"
DOCUMENTS="$HOME/Documents"
SCRIPTS="$HOME/.scripts"
SYSTEM="$(uname -n | tr '[:upper:]' '[:lower:]')"
if [[ $SYSTEM == "pop-os" ]] || [[ $SYSTEM == "ez-pop" ]] || [[ $SYSTEM == "laptop-m3vnok27" ]]; then 
	SYSTEM="linux"; 
fi
GH_USER="Arc891"
ALIASES=""
SHELLRC=""

#----------------------------#




#------# NIXOS #------#

alias nix_search='f(){ xdg-open "https://search.nixos.org/packages?channel=23.11&from=0&size=50&sort=relevance&type=packages&query=$1"; unset -f f; }; f'
alias nix-shell='nix-shell --run zsh'
alias nix-generatons='nixos-rebuild list-generations'

#----------------------------#



#------# HYPRLAND #------#

alias hpr='hyprctl'
alias hpm='hyprctl monitors'
alias hpc='hyprctl clients'

alias rh='$HOME/.config/hypr/hyprland.editor'
diffh() {
  d=$(diff ~/.config/hypr/hyprland.conf ~/.dotfiles/.config/hypr/hyprland.conf)
  if [ -z $d ]; then
    echo "Same file, removing from ~/.conf...";
    rm ~/.config/hypr/hyprland.conf;
    echo "Done.";
  else 
    echo "Different. Check before removing."
  fi
}

#----------------------------#


#------# BASH ALIASES #------#

#------# LS REPLACEMENTS #------#

#--# COLORLS #--#

# if [ -x "$(command -v colorls)" ]; then
	#alias ls='colorls --sd'
	#alias lse='colorls -1'
	#alias lsd='colorls -d'
	#alias lsf='colorls -f'
	#alias lst='colorls --tree'
	#alias lsg='colorls --gs --tree'
	#alias lsts='f(){ colorls --tree=2; unset -f f; }; f'
	#alias lstn='f(){ colorls --tree="$1"; unset -f f; }; f'
# fi
#---------------#

#--# EXA #--#
if [ -x "$(command -v eza)" ]; then
	alias ls='eza --icons --group-directories-first'
	alias lse='ls -1'
	alias lsd='ls -D'
	alias lsf='ls -f'
	alias lst='ls -T'
	alias lsg='ls -T --git'
	alias lsts='ls -T -L 2'
	alias lstn='f(){ ls -T -L "$1"; unset -f f; }; f'
fi
#-----------#

#--# BAT #--#
if [ -x "$(command -v bat)" ]; then
  alias cat='bat'
elif [ -x "$(command -v batcat)"]; then
  alias cat='batcat'
fi
#-----------#

#-----------------#

function cls() {
	DIR="$*";
	# if no DIR given, go home
	if [ $# -lt 1 ]; then 
		DIR=$HOME;
    	fi;
    	builtin cd "${DIR}" && \
	ls
}


alias ll='pwd && ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsl='pwd && ls'
alias cd.='cd ..'
alias cd~='cd $HOME'
alias cd-='cd -'
alias cpv='rsync -ah --info=progress2'

#----------------------------#




#------# FUNCTIONS #------#

vps() {
  alacritty -e ssh vps &;
}


update_discord() {
  URL="https://discord.com/api/download?platform=linux&format=deb"
  VERSION=$(curl -I $URL | grep location | awk -F 'discord-' '{print $2}' | awk -F '.deb' '{print $1}');
  INSTALLED=$(dpkg -l | grep discord | awk '{print $3}')
  if [[ $VERSION != $INSTALLED ]]; then
    echo -e "Discord versions do not match:\n"; 
    echo "$VERSION - $INSTALLED";
    curl -L -o /tmp/discord-$VERSION.deb $URL;
    sudo apt install /tmp/discord-$VERSION.deb;
    mv /tmp/discord-$VERSION.deb $HOME/Downloads/Apps/; 
  else 
    echo "Discord is up to date.";
  fi 
}


updates() {
  sudo apt update;
  sudo apt upgrade;
  update_discord;
}


rmln() {
	rm $ALIASES;
	ln $DOTFILES/config/bash_aliases $ALIASES;
}

find_aliases() {
	if [ -f $HOME/.bash_aliases ]; then
		ALIASES="$HOME/.bash_aliases";
	elif [ -f $HOME/.bashrc.d/aliases ]; then
		ALIASES="$HOME/.bashrc.d/aliases";
	else
		echo "No standard aliases file found, setting default to ~/.aliases";
		ALIASES="$HOME/.aliases";
	fi 
	#echo $ALIASES
}

find_shellrc() {
	if [[ $SHELL == "$(which bash)" ]]; then
		SHELLRC="$HOME/.bashrc";
	elif [[ $SHELL == "$(which zsh)" ]]; then
		SHELLRC="$HOME/.zshrc";
	else
		echo "Current shell not recognized in find_shellrc(), please add rc file option"
		echo "Setting current default to ~/.bashrc"
		SHELLRC="$HOME/.bashrc"
	fi	
}

trans() { sh -c "xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * $1 / 100)))"; }

mcd() { mkdir -p $1; cd $1; }

rename() {
	if [ -z "$1" ]; then
		echo "No parameters given"
		return 1
	else
		for f in *$1*; do
			echo mv -i -- "$f" "${f//$1/$2}"
		done

		read -p "Are you sure you want to make these changes? [N/y] " confirm;
		
		if [ -z "$confirm" ] || [ "$confirm" = "n" ] || [ "$confirm" = "N" ]; then
			echo "Aborting..."
			return 0
		
		elif [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
			echo "Changing file names..."
			
			for f in *$1*; do 
				mv -i -- "$f" "${f//$1/$2}"
			done
		
			ls;
			
		else
			echo "Bad input, aborting..."
		fi
	fi
}


extract() {
	if [ -z "$1" ]; then
    		# display usage if no parameters given
    		echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    		echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    		return 1
 	else
    		for n in $@
    		do
      			if [ -f "$n" ] ; then
          		case "${n%,}" in
            			*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         		     tar xvf "$n"       ;;
            			*.lzma)      unlzma ./"$n"      ;;
            			*.bz2)       bunzip2 ./"$n"     ;;
            			*.rar)       unrar x -ad ./"$n" ;;
            			*.gz)        gunzip ./"$n"      ;;
            			*.zip)       unzip ./"$n"       ;;
            			*.z)         uncompress ./"$n"  ;;
            			*.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         		     7z x ./"$n"        ;;
            			*.xz)        unxz ./"$n"        ;;
            			*.exe)       cabextract ./"$n"  ;;
            			*)
                         	echo "extract: '$n' - unknown archive method"
                         	return 1
                         	;;
          		esac
      			else
          			echo "'$n' - file does not exist"
          			return 1
      			fi
    		done
	fi
}

#----------------------------#



#------# CONNECTIONS  #------#

wifi_connect() {
	nmcli dev wifi list;
	read -p "Enter the network name or SSID: " network_name;
	echo 'Connecting to' $network_name;
	sudo nmcli dev wifi connect $network_name;
}

alias wls='nmcli dev wifi list'
alias wlsc='wls && wifi_connect'
alias myip='curl ifconfig.me && printf "\n"'
alias myipl="ifconfig $(ifconfig | grep wlp | awk -F':' '{print $1}') | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

myips() {
	printf "Global ip: ";
	curl ifconfig.me;
	printf "\n Local ip: "
	myipl;
}


alias ngtcp='ngrok tcp 22'

#----------------------------#



#------# SYSTEM CONTROL #------#

cons() { . $DOTFILES/scripts/conservation_mode.sh "$1"; }
swap-cons() { . $DOTFILES/scripts/swap_cons_mode.sh; }
echo-cons() { . $DOTFILES/scripts/echo_cons.sh; }

memus() { ps -aux | rg "$1" | awk '{print $4}' | awk '{s+=$1} END {print s}'; }

cus() { ps -aux | rg "$1" | awk '{print $3}' | awk '{s+=$1} END {print s/16}'; }

usage() { echo "CPU: $(cus $1)%, MEM: $(memus $1)%"; }

alias duah='du -ah "$1" | grep -v "/$" | sort -rh'

alias battery='sudo tlp-stat -b'
alias batc='cat /sys/class/power_supply/BAT*/capacity'
alias batstart='sudo cat /sys/class/power_supply/BAT0/charge_start_threshold'
alias batstop='sudo cat /sys/class/power_supply/BAT0/charge_stop_threshold'
alias btc='bluetoothctl'
alias brf='brightnessctl set 100%'

alias chownme='sudo chown $USER:$USER'

#alias sdn='shutdown now'
alias sdn='systemctl poweroff'

#----------------------------#


#------# GIT #------#

push() {
	git add *;
	git commit -m "$1";
	git push;
}

mkreponew() {
	if [[ $# < 2 ]]
	then
		echo "Too few arguments ($#). Usage: createrepo {repo_name} {<private>: true / false }"
	else
		TOKEN="$(cat $HOME/.token)"	
		curl -s -u $GH_USER:$TOKEN https://api.github.com/user/repos -d '{"name":"'$1'","private":'$2'}'; 
		
		mcd $1;
		echo "# $1" > README.md;
		git init -b main;
		git add *
		git commit -m "Initial commit";
		git remote add origin git@github.com:$GH_USER/$1.git;
		git push -u origin main;
		xdg-open https://github.com/$GH_USER/$1 >/dev/null;
	fi	
}

mkrepo() {
	if [[ $# < 2 ]]
	then
		echo "Too few arguments ($#). Usage: createrepo {repo_name} {<private>: true / false }"
	else
		TOKEN="$(cat $HOME/.token)"	
		curl -s -u $GH_USER:$TOKEN https://api.github.com/user/repos -d '{"name":"'$1'","private":'$2'}'; 
		
		git init -b main;
		git add *
		git commit -m "Initial commit";
		git remote add origin git@github.com:$GH_USER/$1.git;
		git push -u origin main;
		xdg-open https://github.com/$GH_USER/$1 >/dev/null;
	fi	
}

rmrepo() {
	TOKEN="$(cat $HOME/.token)";
	curl \
  	-X DELETE \
  	-H "Accept: application/vnd.github.v3+json" \
  	-H "Authorization: token $TOKEN" \
  	https://api.github.com/repos/$GH_USER/$1
	cd .. && rm -rf $1;
}

alias gs='git status'
alias gts='git status'
alias gc='git clone'
alias ga='f(){ git add "$1"; unset -f f; }; f'
alias gaa='git add .'
alias gp='git push'
alias gpl='git pull'
alias gplp='git pull && git push'
alias gcm='f(){ git commit -S -m "$1"; unset -f f; }; f'
alias gopen='f(){ xdg-open https://github.com/$GH_USER/$1 >/dev/null; unset -f f; }; f'
alias gurl='git remote get-url origin'
alias gclmy='f() { git clone git@github.com:Arc891/$1.git; unset -f f; }; f'

#----------------------------#



#------# OPENING FOLDERS #------#

school() { cd $DOCUMENTS/School/BScCSy"$1"/Period"$2"/"$3"; }
scopen() { school "$1" "$2" && open "$3" > /dev/null 2>&1; }

alias open='f(){ xdg-open $("pwd")/"$1"; unset -f f; }; f'
alias coding='f(){ cd $CODING/"$1"; unset -f f; }; f'
alias notes='f(){ cd $HOME/Notes/"$1"; unset -f f; }; f'
alias cpd='f(){ coding Python/"$1"; unset -f f; }; f'
alias hc='cpd HackerChat'
alias hch='p $CODING/Python/HackerChat/hackerchat.py'
alias hs='hc && p $CODING/Python/HackerChat/hackerserver.py'
alias dot='f() { cd $HOME/.dotfiles/"$1"; unset -f f; }; f'
alias cnf='f() { cd $HOME/.config/"$1"; unset -f f; }; f'
alias conf='cnf'
alias home='cd $HOME'
alias docs='cd $DOCUMENTS'
alias pers='cd $DOCUMENTS/Personal'
alias scl='cd $DOCUMENTS/School'
alias coco='cd $DOCUMENTS/CoCoS'
alias rustl='cd $CODING/rustlings'
alias rustlw='rustl && rustlings watch'
alias bach='cd $DOCUMENTS/BachelorThesis'

spp() {
	nums='^[0-9]+$'
	if [[ $1 -ge 7 ]]; then
		echo "Only 6 dirs, enter valid number"
	elif ! [[ $1 =~ $nums ]]; then
		echo "Only numbers valid as argument"
	else
		sp && cd program$1
	fi
}

#----------------------------#



#------# EDITING FILES/FOLDERS #------#

alias fzf="fzf --multi \
  --height=50% \
  --margin=5%,2%,2%,5% \
  --border=double \
  --border-label='|  󰥨 󰫳󰬇󰫳 󰱼  |' \
  --info=inline \
  --prompt='$>' \
  --pointer='→' \
  --marker='♡' \
  --header='CTRL-c or ESC to quit' \
  --bind='ctrl-r:reload(eval $FZF_DEFAULT_COMMAND)' \
  --bind='del:execute(rm -ri {})' \
  --bind='del:+reload(eval $FZF_DEFAULT_COMMAND)' \
  --color='dark,fg:magenta' \
  --preview='stat {}' \
  --"

alias fzf_file='f() { 
  FZF_DEFAULT_COMMAND="find $1 -type f";
  fzf --multi \
    --preview="sudo cat {}" \
    --preview-label="[ File Contents ]"; 
  unset -f f; 
}; f'

alias fzf_dir='f() { 
  FZF_DEFAULT_COMMAND="find $1 -type d"; 
  fzf --multi \
    --preview="sudo tree -C {}" \
    --preview-label="[ Dir Contents ]"; 
  unset -f f; 
}; f'

alias vf='f() {
  if [[ $# -eq 0 ]]; then
    FILE=$(fzf_file);
  else 
    FILE=$(fzf_file --query $1);
  fi
  if [[ ! -z $FILE ]]; then 
    nvim $FILE;
  fi;
  unset -f f;
}; f'

alias vne='f() { 
  if [[ $# -ne 0 ]]; then 
    v $1; 
  fi; 
  unset -f f; 
}; f'

alias vfn='vne $(fzf_file $HOME/Notes)'
alias vfd='vne $(fzf_dir)'
alias vfa='sv $(fzf_file /)'

alias v.='v .'
alias sv='sudo nvim'
alias vb='v $ALIASES'
alias vbr='v $SHELLRC'
alias vms='v $DOTFILES/scripts/vim_shortcuts.txt'
alias vrc='sv /etc/vim/vimrc'
alias vnc='sv /etc/nixos/configuration.nix'
alias vssh='v $HOME/.ssh/config'
alias vbsp='v $HOME/.config/bspwm/bspwmrc'
alias vsx='v $HOME/.config/sxhkd/sxhkdrc'
alias polyconf='v $HOME/.config/bspwm/rices/$RICETHEME/polybar/config.ini'
alias polymods='v $HOME/.config/bspwm/rices/$RICETHEME/polybar/modules.ini'
alias rice='v .config/bspwm/rices/$RICETHEME/'
alias yml='code $HOME/.config/alacritty/alacritty.yml'
alias esp='code $HOME/.config/espanso'
alias rscripts='v $HOME/.config/bspwm/scripts/'
alias vh='v $HOME/.config/hypr/'
alias vhc='v $HOME/.config/hypr/hyprland.conf'
alias vhb='v $HOME/.config/hypr/binds.conf && rh'
alias vhm='v $HOME/.config/hypr/monitors.conf && rh'
alias vhe='v $HOME/.config/hypr/exec.conf && rh'
alias vhw='v $HOME/.config/hypr/windowrules.conf && rh'
alias vhs='v $HOME/.config/hypr/system.conf && rh'
alias vw='v $HOME/.config/waybar/'
alias vwc='v $HOME/.config/waybar/config.jsonc'
alias vws='v $HOME/.config/waybar/style.css'
alias idea='eureka'
alias todo='vf todo.md'
alias cron='EDITOR=vim crontab'
alias crone='EDITOR=vim crontab -e'

#----------------------------#



#------# DOCKER #------#

alias d='docker'
alias dc='docker container'
alias dcs='dc start'
alias dcp='dc stop'
alias da='docker attach'

#----------------------------#



#------# CODING #------#

alias cg='cargo'
alias cr='cargo run'
alias cb='cargo build'
alias cre='RUST_BACKTRACE=full cargo run > err.out 2>&1'

alias leetr='clear && rustc -o rust main.rs && RUST_BACKTRACE=full ./rust'
alias leetcpp='clear && g++ -o cpp main.cpp && ./cpp'

new_leet_dir() {
  if [[ ! -f ./template.cpp ]]; then 
    echo "Not in LeetCode dir. First cd and then try again";
    return;
  fi
  echo "Enter new dirname: ";
  read dirname;
  mkdir $dirname;
  echo "Language extension: ";
  read prog;
  cp ./template.$prog $dirname/main.$prog;
  cd $dirname;
  code main.$prog;
}

#----------------------------#



#------# 1 LETTER SHORTHANDS #------#

alias v='nvim'
alias q='exit 0'
alias p='python3'

#----------------------------#



#------# PACKAGE MANAGER #------#

alias sup='sudo apt update'
#alias supg='sup && sudo apt upgrade'
alias supg='tmux new-session -s apt_update "exec zsh -ic \"updates\""'

alias pcyu='sudo pacman -Syyu'
alias pac='sudo pacman -S'
alias ys='yay -S'

#----------------------------#




#------# FIND FILES #------#

alias fhere='find . -name'
alias fall='sudo find / -name'
alias fth='tree -af --ignore-case | grep'
alias fta='tree -af --ignore-case / | grep'
alias ft='f() {	tree -af --ignore-case "$1" | grep "$2"; unset -f f;}; f'
alias smt='tree -ah -L 2'
alias bgt='tree -ahRFC --du --dirsfirst --filelimit=40'

tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null; }

#----------------------------#



#------# SPICETIFY #------#

alias spia='spicetify apply'
alias spith='f(){ spicetify config current_theme "$1"; unset -f f; }; f'
alias spics='f(){ spicetify config color_scheme "$1"; unset -f f; }; f'

#----------------------------#



#------# ASCII ART #------#

alias matrix1='cat $ASCII/matrix-Slant1'
alias matrix2='cat $ASCII/matrix-Slant2'
alias welcome='cat $ASCII/$SYSTEM-Slant'
alias welcome-small='cat $ASCII/$SYSTEM-small'
alias nwelcome="echo Arc8\'s $SYSTEM"
alias awelcome="echo Anamata\'s $SYSTEM"
alias ascii='xdg-open https://patorjk.com/software/taag &'

get_print_width() {
    if [[ $# -eq 1 ]]; then
        local FILE="$ASCII/$SYSTEM-small"
    else
        local FILE="$ASCII/$SYSTEM-Slant"
    fi

    echo $(head -n 2 $FILE | tail -n 1 | awk '{print length}');
}

set_welcome_print() {
    if [ -z "$#" ]; then
	    echo "Give an input of 0 for prints off, anything else for on";
    fi
    echo "$1" > $HOME/.config/print;
}

print_welcome() {
    if [[ $USER == "anamata" ]]; then 
	    awelcome
    else
    	if [ -f $HOME/.config/print ]; then
    		if [[ $(cat $HOME/.config/print) == "0" ]]; then
	   			return;
			  fi
    	fi
    	if [[ $COLUMNS -le $(get_print_width -s) ]]; then
			  nwelcome;
    	elif [[ $COLUMNS -le $(get_print_width) ]]; then
		  	welcome-small;
		  else 
			  welcome;
		  fi
    fi
}

#----------------------------#



#------# REFRESH #------#

alias cl='clear && print_welcome'
alias cle='clear'
alias cln='clear && neofetch'
alias clp='clear && pfetch'
alias rc='clear && source $SHELLRC'
alias rf='source $SHELLRC'

#----------------------------#



#------# HISTORY #------#

h() {
	if [[ $# -eq 1 ]]; then
		history "$1"
	elif [[ $# -eq 2 ]]; then
		history "$1" | grep "$2"
	elif [[ $# -eq 3 ]]; then
		history "$1" | grep -"$3" "$2"
	elif [[ $# -eq 0 ]]; then
		history 1
	else
		echo "Wrong usage. Use h <num=1> <grep term> <flag>"
	fi
}

hgrep () { 
	fc -lm "*$@*" 1; 
}

alias hs='history 1 | grep'
alias hsi='history 1 | grep -i'
alias vhis='v ~/.zsh_history'

HISTCONTROL='ignoredups'

#----------------------------#



#------# RANDOM STUFF #------#

alias bws='rbw sync'

alias gdm-banner='v /etc/dconf/db/gdm.d/01-banner-message' 

alias beep-off='xset b off'

alias pipes_sh='pipes.sh -t 3 -p 4 -r 0'
alias pipes-sh='pipes -t 3 -p 4 -r 0'

alias start_waybar='waybar &>/dev/null'
alias reload_waybar='pkill -SIGUSR2 waybar'
alias restart_waybar='pkill waybar && start_waybar'

alias restart='pkill $1 && $1'

#----------------------------#

#------# GAMES #------#

alias protontricks='flatpak run com.github.Matoking.protontricks'
alias protontricks-launch='flatpak run --command=protontricks-launch com.github.Matoking.protontricks'

function find_steam_game_id() {
    find $HOME/snap/steam/common/.local/share/Steam/steamapps/ -maxdepth 1 -type f -name '*.acf' -exec awk -F '"' '/"appid|name/{ printf $4 "|" } END { print "" }' {} \; | column -t -s '|' | sort -k 2 | grep -i $1;
}

function run_steam_game() {
  GAME_ID=$(find_steam_game_id $1);
  #steam steam://rungameid/$GAME_ID
  steam -applaunch $GAME_ID
}

alias speedrunners='steam -applaunch 207140'

alias nvsmi='nvidia-smi'

#----------------------------#



#------# STARTUP COMMANDS #------#
shopt -s expand_aliases

find_shellrc
find_aliases
cl
pfetch
#print_welcome
#beep-off
#neofetch
#. "$HOME/.cargo/env"
