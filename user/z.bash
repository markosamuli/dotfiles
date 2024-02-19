#!/usr/bin/env bash

if command -v zoxide > /dev/null; then
    eval "$(zoxide init zsh)"
elif [ -n "${DOTFILES}" ] && [ -f "${DOTFILES}/z/z.sh" ]; then
    # shellcheck disable=SC1090,SC1091
    . "${DOTFILES}/z/z.sh"
fi
