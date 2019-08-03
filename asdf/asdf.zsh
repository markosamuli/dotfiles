#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# load ASDF version manager
if [ -e "$HOME/.asdf/asdf.sh" ]; then
  export ASDF_DIR="$HOME/.asdf"
  source $ASDF_DIR/asdf.sh
fi
