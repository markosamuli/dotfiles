#!/bin/zsh

# load Ansible managed .pyenvrc config
if [ -e "$HOME/.pyenv/.pyenvrc" ]; then
  source $HOME/.pyenv/.pyenvrc
fi
