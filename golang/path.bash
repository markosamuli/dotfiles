#!/usr/bin/env bash

# Golang projects
if [ -d "$HOME/Projects/golang" ]; then
  export GOPATH=$HOME/Projects/golang
  export PATH=$PATH:$GOPATH/bin
fi

# Load GAE tools to Golang
if [ -d "$HOME/opt/go_appengine" ]; then
  export PATH=$PATH:$HOME/opt/go_appengine
fi
