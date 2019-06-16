#!/bin/zsh

# load ASDF version manager
if [ -e "$HOME/.asdf/asdf.sh" ]; then
  export ASDF_DIR="$HOME/.asdf"
  source $ASDF_DIR/asdf.sh
fi
