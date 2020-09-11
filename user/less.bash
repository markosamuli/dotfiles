#!/usr/bin/env bash

# shellcheck disable=SC2154
if [[ "${platform}" == "macos" ]]; then
    if [[ -x "/usr/local/bin/less" ]]; then
        export MANPAGER=/usr/local/bin/less
    fi
fi
