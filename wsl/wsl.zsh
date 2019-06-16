#!/bin/zsh

# WSL specific configuration
if [[ "$platform" == "wsl" ]]; then
  # precommit on Windows filesystem
  export SKIP=check-executables-have-shebangs
fi
