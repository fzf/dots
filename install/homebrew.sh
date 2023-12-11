
#!/bin/bash

which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  brew update
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew bundle --file=$HOME/.dots/Brewfile
