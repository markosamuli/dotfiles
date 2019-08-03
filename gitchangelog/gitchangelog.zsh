#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# Custom gitchangelog config
if [ -e "$HOME/.gitchangelog.rc" ]; then
  export GITCHANGELOG_CONFIG_FILENAME="$HOME/.gitchangelog.rc"
fi
