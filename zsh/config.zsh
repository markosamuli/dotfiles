#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# load functions
fpath=($DOTFILES/functions $fpath)
autoload -U "$DOTFILES"/functions/*(:t)
