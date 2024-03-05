if [[ $1 != "" ]]; then
  NOTE="$1_notes"
else
  NOTE="notes"
fi

nvim $HOME/Documents/Notes/$NOTE.md
