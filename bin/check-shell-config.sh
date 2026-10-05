#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# shellcheck disable=SC2016
blacklist=(
    'export GOPATH='
    'export NVM_DIR='
    'export CLOUDSDK_ROOT_DIR='
    'export ASDF_DIR='
    'export RBENV_ROOT='
    'source(.*)/nvm.sh'
    'source(.*)/asdf.sh'
    'source(.*)/.pyenv'
    'export PATH=(.*)$GOPATH'
    'export PATH=(.*)/.rbenv'
    'export PATH=(.*)/.tfenv'
    'rbenv init'
    'pyenv init'
    # An absolute home directory path. Tool installers append their own
    # setup with one (bun's completion block, for example) when they edit
    # the shell config, which here writes through the symlink into this
    # public repository. Setup belongs in a module, with $HOME.
    '/(Users|home)/'
)

find_blacklisted_patterns() {
    local file=$1
    local match
    local errors=0
    for pattern in "${blacklist[@]}"; do
        # Ignore commented-out lines: a pattern inside a comment is a note
        # about what deliberately is not done here, not an active setting.
        match=$(grep -E -H -n "${pattern}" "${file}" |
            grep -vE '^[^:]+:[0-9]+:[[:space:]]*#')
        if [ -n "${match}" ]; then
            echo "${match}"
            errors=$((errors + 1))
        fi
    done
    if [ $errors -gt 0 ]; then
        echo "${errors} unwanted line(s) found in ${file}"
        return 1
    else
        return 0
    fi
}

status=0
for file in "$@"; do
    find_blacklisted_patterns "${file}" || status=1
done
exit ${status}
