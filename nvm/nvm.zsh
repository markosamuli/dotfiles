#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# load nvm if installed
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" # This loads nvm
fi
