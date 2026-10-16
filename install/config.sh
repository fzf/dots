#!/bin/bash

# Files in config/ link to ~/.config/<file>.
# Directories in config/ link each of their files into ~/.config/<dir>/<file>,
# so apps that keep runtime state beside their config (herdr: sockets, logs,
# session.json) keep that state out of the repo.
for location in $HOME/.dots/config/*; do
  file="${location##*/}"
  if [ -d "$location" ]; then
    mkdir -p "$HOME/.config/$file"
    for sub in "$location"/*; do
      name="${sub##*/}"
      echo "Linking '$HOME/.config/$file/$name' to '$sub'"
      ln -sf "$sub" "$HOME/.config/$file/$name"
    done
  else
    echo "Linking '$HOME/.config/$file' to '$location'"
    ln -sf "$location" "$HOME/.config/$file"
  fi
done
