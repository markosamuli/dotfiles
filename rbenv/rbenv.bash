#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Initialise rbenv only once
if [ -z "${RBENV_ROOT}" ]; then
  if [ -d "$HOME/.rbenv" ]; then
    export PATH=$HOME/.rbenv/bin:$PATH;
    export RBENV_ROOT=$HOME/.rbenv;
    eval "$(rbenv init -)";
  fi
fi
