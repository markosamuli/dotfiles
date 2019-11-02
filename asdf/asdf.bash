#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Initialise asdf-vm
if [ -e "$HOME/.asdf/asdf.sh" ]; then
    export ASDF_DIR="$HOME/.asdf"
    source $ASDF_DIR/asdf.sh
fi
