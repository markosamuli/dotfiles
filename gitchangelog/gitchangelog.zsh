#!/bin/zsh

# Custom gitchangelog config
if [ -e "$HOME/.gitchangelog.rc" ]; then
  export GITCHANGELOG_CONFIG_FILENAME="$HOME/.gitchangelog.rc"
fi
