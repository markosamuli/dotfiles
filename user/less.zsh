#!/bin/zsh

if [[ "$platform" == "macos" ]]; then
    if [[ -x "/usr/local/bin/less" ]]; then
        export MANPAGER=/usr/local/bin/less
    fi
fi
