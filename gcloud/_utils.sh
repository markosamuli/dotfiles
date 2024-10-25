#!/usr/bin/env bash

# Use the full path so it will work even while switching between Python versions
_dotfiles_python3_path() {
    local python3_path
    local python3_version
    if command -v pyenv >/dev/null; then
        _dotfiles_python3_pyenv_path
    fi
}

_dotfiles_python3_pyenv_path() {
    local python3_path
    local python3_version
    if ! command -v pyenv >/dev/null; then
        echo "WARNING: pyenv not found" >&2
        return 1
    fi
    python3_version=$(pyenv whence python3.12 | tail -1)
    if [ -z "${python3_version}" ]; then
        echo "WARNING: python 3.12 version not found, try installing it with pyenv" >&2
        return 1
    fi
    python3_path=$(PYENV_VERSION=${python3_version} pyenv which python3.12)
    if [ -z "${python3_path}" ]; then
        echo "WARNING: python3.12 binary not found" >&2
        return 1
    fi
    echo "${python3_path}"
}

# Initialise CLOUDSDK_PYTHON
_dotfiles_cloudsdk_python() {
    local cloudsdk_python
    cloudsdk_python=$(_dotfiles_python3_path)
    if [ -n "${cloudsdk_python}" ]; then
        export CLOUDSDK_PYTHON="${cloudsdk_python}"
        export CLOUDSDK_PYTHON_SITEPACKAGES=1
    fi
}

_dotfiles_gke_gcloud_auth_plugin() {
    if command -v gke-gcloud-auth-plugin >/dev/null; then
        export USE_GKE_GCLOUD_AUTH_PLUGIN=True
    fi
}
