#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Initialise Linuxbrew
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    # shellcheck disable=SC2046
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
