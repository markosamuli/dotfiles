#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

if [ -e "$HOME/.pyenv/.pyenvrc" ]; then
    # load Ansible managed .pyenvrc config
    source $HOME/.pyenv/.pyenvrc
elif [ -d "$HOME/.pyenv" ]; then
    # initialise manual installs
    if ! command -v pyenv >/dev/null; then
        echo "WARNING: pyenv not found on PATH" >&2
    fi
    eval "$(pyenv init -)"
fi

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
