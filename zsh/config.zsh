#!/bin/zsh

# load functions
fpath=($DOTFILES/functions $fpath)
autoload -U "$DOTFILES"/functions/*(:t)
