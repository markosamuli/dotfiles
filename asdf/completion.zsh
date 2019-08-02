#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# load ASDF version manager
if [ -n "$ASDF_DIR" ]; then
  source $ASDF_DIR/completions/asdf.bash

  # terraform completions
  if [ -s "$ASDF_DIR/shims/terraform" ]; then
    complete -o nospace -C "$ASDF_DIR/shims/terraform" terraform
  fi
fi
