#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

if [ -e "${HOME}/.asdf/asdf.sh" ]; then
    export ASDF_DIR="${HOME}/.asdf"
    # shellcheck disable=SC1090
    source "${ASDF_DIR}/asdf.sh"
fi
