#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# load Ansible managed .pyenvrc config
if [ -e "$HOME/.pyenv/.pyenvrc" ]; then
    source $HOME/.pyenv/.pyenvrc
elif [ -d "$HOME/.pyenv" ]; then
    eval "$(pyenv init -)"
fi

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
