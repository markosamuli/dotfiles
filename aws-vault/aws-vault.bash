#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# shellcheck disable=SC2154
if [[ "${platform}" == "linux" ]]; then
    # Default to https://www.passwordstore.org/
    if [ -z "${AWS_VAULT_BACKEND}" ]; then
        export AWS_VAULT_BACKEND=pass
    fi
    # shellcheck disable=SC2154
    if [[ "${platform_wsl}" == "true" ]]; then
        # Fix "gpg: decryption failed: No secret key" error
        # https://www.krenger.ch/blog/gopass-gpg-decryption-failed-no-secret-key/
        if [ -z "${GPG_TTY}" ]; then
            GPG_TTY=$(tty)
            export GPG_TTY
        fi
    fi
fi
