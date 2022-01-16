#!/usr/bin/env bash
# Common functions for configuring pyenv.

_dotfiles_init_pyenv() {
    if [ -e "$HOME/.pyenv/.pyenvrc" ]; then
        # load Ansible managed .pyenvrc config
        source $HOME/.pyenv/.pyenvrc
    elif [ -d "$HOME/.pyenv" ]; then
        # initialise manual installs
        if ! command -v pyenv >/dev/null; then  # this should be done in .zprofile
            echo "WARNING: pyenv not found on PATH" >&2
            echo "Have you created .zprofile symlink?" >&2
        else
            eval "$(pyenv init -)"
        fi
    fi
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
}