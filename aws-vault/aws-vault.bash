#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# shellcheck disable=SC2154
if [[ "${platform}" == "linux" ]]; then
    # Default to https://www.passwordstore.org/
    if [ -z "${AWS_VAULT_BACKEND}" ]; then
        export AWS_VAULT_BACKEND=pass
    fi
fi
