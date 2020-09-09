#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1090
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
fi
