#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

## Command history configuration
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.bash_history
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
SAVEHIST=10000
