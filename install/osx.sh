#!/bin/bash

cd ~

which -s brew
if [[ $? != 0 ]] ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  brew update
fi

brew bundle

sudo rm -rf $HOME/.dots
git clone https://gitlab.com/fzf/dots.git $HOME/.dots --quiet

bash $HOME/.dots/install/home.sh
bash $HOME/.dots/install/qutebrowser.sh
