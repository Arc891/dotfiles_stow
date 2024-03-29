# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

to_export=("/usr/local/opt/tcl-tk/bin" 
           "$HOME/.spicetify" 
           "$HOME/.scripts" 
           "$HOME/.cargo/bin"
           "$HOME/.config/spotifyc"
         )
for p in "${to_export[@]}"
do
	if [[ $(echo $PATH | grep $p) == "" ]]; then
    export PATH=$PATH:$p
  fi
done

# Zsh aliases
alias .="source"
alias vz="nvim $HOME/.zshrc"

# Zsh prompts
# PS1="[%{$fg[red]%}%n%{$reset_color%}: %{$fg[blue]%}%~%{$reset_color%}] %% "
autoload -U colors && colors

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Own aliases
source ~/.bash_aliases

# Zsh plugins
source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
source ~/.config/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source ~/.config/zsh-z/zsh-z.plugin.zsh
#source ~/.config/sudo.plugin.zsh

export $(envsubst < $HOME/.env)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

