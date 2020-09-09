#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Load nvm bash_completion
if [ -n "${NVM_DIR}" ]; then
    if [ -s "${NVM_DIR}/bash_completion" ]; then
        # shellcheck disable=SC1090
        . "${NVM_DIR}/bash_completion"
    fi
fi
