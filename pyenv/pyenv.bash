#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Using .pyenvrc file generated by markosamuli.pyenv Ansible role
if [ -e "$HOME/.pyenv/.pyenvrc" ]; then
  source $HOME/.pyenv/.pyenvrc
fi

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
