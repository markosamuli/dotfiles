#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# Homebrew configuration
[ -e "$HOME/.homebrewrc" ] && source $HOME/.homebrewrc

# To fix brew doctor's warning
# https://github.com/pyenv/pyenv#homebrew-in-macos
# if command -v pyenv >/dev/null; then
#     alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
# fi
