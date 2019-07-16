#!/bin/zsh

# Set GOPATH if not previously defined
if [ -z "$GOPATH" ]; then
  if [ -d "$HOME/go" ]; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
  elif [ -d "$HOME/Projects/golang" ]; then
    export GOPATH=$HOME/Projects/golang
    export PATH=$PATH:$GOPATH/bin
  fi
fi

# Load GAE tools to Golang
if [ -d "$HOME/opt/go_appengine" ]; then
  export PATH=$PATH:$HOME/opt/go_appengine
fi
