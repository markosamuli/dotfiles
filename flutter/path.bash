#!/usr/bin/env bash

if [ -d "$HOME/opt/flutter/bin" ]; then
    PATH="$HOME/opt/flutter/bin:$PATH"
fi

# Pub installs executables into $HOME/.pub-cache/bin, which is not on your path.
if [ -d "$HOME/.pub-cache/bin" ]; then
    PATH="$PATH:$HOME/.pub-cache/bin"
fi
