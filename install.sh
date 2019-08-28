#!/bin/bash
git clone https://fzf@gitlab.com/fzf/dotfiles.git $HOME/.dots --quiet

for location in $HOME/dots/home/*; do
  file="${location##*/}"
  echo "Linking '$file' to '$location'"
  ln -sf "$location" "$HOME/.$file"
done
