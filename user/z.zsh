#!/bin/zsh

if command -v zoxide > /dev/null; then
    eval "$(zoxide init zsh)"
elif [ -n "${DOTFILES}" ] && [ -f "${DOTFILES}/z/z.sh" ]; then
    . "${DOTFILES}/z/z.sh"
fi
