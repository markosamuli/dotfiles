#!/bin/zsh

# Use the full path so it will work even while switching between Python versions
_full_python3_path() {
    local python3_path
    if command -v pyenv >/dev/null; then
        python3_path=$(pyenv which python3)
    fi
    if [ -z "${python3_path}" ]; then
        python3_path="python3"
    fi
    echo "${python3_path}"
}

# Use python3 over python2
if command -v python3 >/dev/null; then
    CLOUDSDK_PYTHON=$(_full_python3_path)
    export CLOUDSDK_PYTHON
fi
