#!/bin/bash

for location in $HOME/.dots/config/*; do
  file="${location##*/}"
  echo "Linking '$HOME/.config/.$file' to '$location'"
  ln -sf "$location" "$HOME/.config/$file"
done
