#!/usr/bin/env bash

__linuxbrew_completion_files() {
    if [ -z "${HOMEBREW_PREFIX}" ]; then
        return 1
    fi
    if [ ! -d "${HOMEBREW_PREFIX}/etc/bash_completion.d" ]; then
        return 1
    fi
    if ! type _get_comp_words_by_ref &>/dev/null; then
        return 1
    fi
    # shellcheck disable=SC2206
    linuxbrew_completion_files=(${HOMEBREW_PREFIX}/etc/bash_completion.d/*)
    # shellcheck disable=SC2128
    if [ "${linuxbrew_completion_files}" = "${HOMEBREW_PREFIX}/etc/bash_completion.d/*" ]; then
        linuxbrew_completion_files=()
    fi
}

if __linuxbrew_completion_files; then
    for file in "${linuxbrew_completion_files[@]}"; do
        # shellcheck disable=SC1090
        source "${file}"
    done
    unset linuxbrew_completion_files
fi
