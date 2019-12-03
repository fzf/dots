#!/bin/bash
git clone https://gitlab.com/fzf/dots.git $HOME/.dots --quiet

for location in $HOME/.dots/home/*; do
  file="${location##*/}"
  echo "Linking '$file' to '$location'"
  ln -sf "$location" "$HOME/.$file"
done

ln -sf $HOME/.dots/qutebrowser $HOME/.qutebrowser
