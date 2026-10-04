#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Set GOPATH if not previously defined
if [ -z "$GOPATH" ]; then
    if [ -d "$HOME/go" ]; then
        export GOPATH=$HOME/go
        export PATH=$PATH:$GOPATH/bin
    elif [ -d "$HOME/Projects/go" ]; then
        export GOPATH=$HOME/Projects/go
        export PATH=$PATH:$GOPATH/bin
    elif [ -d "$HOME/Projects/golang" ]; then
        export GOPATH=$HOME/Projects/golang
        export PATH=$PATH:$GOPATH/bin
    fi
fi
