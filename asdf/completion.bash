#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

if [ -e "${HOME}/.asdf/completions/asdf.bash" ]; then
    # shellcheck disable=SC1090
    source "${HOME}/.asdf/completions/asdf.bash"
fi
