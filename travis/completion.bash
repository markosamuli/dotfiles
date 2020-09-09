#!/usr/bin/env/bash
# vim :set ts=2 sw=2 sts=2 et :

# tab completion for travis
if [ -f "${HOME}/.travis/travis.sh" ]; then
    # shellcheck disable=SC1090
    source "${HOME}/.travis/travis.sh"
fi
