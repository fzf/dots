#!/bin/bash

cd ~

which -s brew
if [[ $? != 0 ]] ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
fi

sudo rm -rf $HOME/.dots
git clone https://gitlab.com/fzf/dots.git $HOME/.dots --quiet

brew bundle --file $HOME/.dots/Brewfile

bash $HOME/.dots/install/home.sh
bash $HOME/.dots/install/qutebrowser.sh
