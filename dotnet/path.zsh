#!/bin/zsh

if [ -d "$HOME/.dotnet/tools" ]; then
    export PATH="$PATH:$HOME/.dotnet/tools"
fi
