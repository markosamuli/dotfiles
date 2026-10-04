#!/bin/zsh

if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Make sure to include MacPorts before Homebrew.
if [ -d "/opt/local" ]; then
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi
