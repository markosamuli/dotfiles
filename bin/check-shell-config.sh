#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

blacklist=(
    'export GOPATH='
    'export NVM_DIR='
    'export CLOUDSDK_ROOT_DIR='
    'export ASDF_DIR='
    'export RBENV_ROOT='
    'source(.*)/nvm.sh'
    'source(.*)/asdf.sh'
    'source(.*)/.pyenv'
    'export PATH=(.*)\$GOPATH'
    'export PATH=(.*)/.rbenv'
    'rbenv init'
    'pyenv init'
)

find_blacklisted_patterns() {
    local file=$1
    local match
    local errors=0
    for pattern in "${blacklist[@]}"; do
        match=$(grep -E -H -n "${pattern}" "${file}")
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
