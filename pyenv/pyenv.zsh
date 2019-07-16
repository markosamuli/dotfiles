#!/bin/zsh

# load Ansible managed .pyenvrc config
if [ -e "$HOME/.pyenv/.pyenvrc" ]; then
  source $HOME/.pyenv/.pyenvrc
fi

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
