#!/bin/bash

sudo spctl --master-disable

cd ~

bash $HOME/.dots/install/homebrew.sh

rm -rf $HOME/.dots
git clone https://gitlab.com/fzf/dots.git $HOME/.dots --quiet

bash $HOME/.dots/install/homebrew.sh

bash $HOME/.dots/install/asdf.sh
bash $HOME/.dots/install/fzf.sh
bash $HOME/.dots/install/home.sh
bash $HOME/.dots/install/hammerspoon.sh
bash $HOME/.dots/install/karabiner.sh
bash $HOME/.dots/install/ohmyzsh.sh
bash $HOME/.dots/install/vim.sh
bash $HOME/.dots/install/vscode.sh
