#!/bin/zsh

# Add local binaries to the PATH
[ -d "$HOME/bin" ] && export PATH=$HOME/bin:$PATH
[ -d "$HOME/.local/bin" ] && export PATH=$HOME/.local/bin:$PATH
