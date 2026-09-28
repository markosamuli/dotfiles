#!/bin/zsh

if [ -f "$HOME/.local/bin/env" ]; then
    . "$HOME/.local/bin/env"
elif [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi