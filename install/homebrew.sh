
#!/bin/bash

which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

source ../home/zshrc

brew bundle --file=$HOME/.dots/Brewfile
