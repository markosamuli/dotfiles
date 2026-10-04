#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# go install puts binaries in $GOPATH/bin. GOPATH defaults to ~/go
# since Go 1.8, so it is not exported here; an explicit one is respected.
if [ -d "${GOPATH:-$HOME/go}/bin" ]; then
    export PATH="$PATH:${GOPATH:-$HOME/go}/bin"
fi
