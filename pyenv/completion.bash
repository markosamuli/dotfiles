#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Load shell completions
if [ -e "${HOME}/.pyenv/completions/pyenv.bash" ]; then
    # shellcheck disable=SC1090
    source "${HOME}/.pyenv/completions/pyenv.bash"
fi
