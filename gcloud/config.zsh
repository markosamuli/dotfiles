#!/bin/zsh

# Use python3 over python2
if command -v python3 >/dev/null; then
    export CLOUDSDK_PYTHON=python3
fi
