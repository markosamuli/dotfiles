#!/bin/zsh

# Load GAE tools to Golang
if [ -d "$HOME/opt/go_appengine" ]; then
  export PATH=$PATH:$HOME/opt/go_appengine
fi
