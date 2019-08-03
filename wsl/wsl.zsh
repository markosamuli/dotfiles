#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# WSL specific configuration
if [[ "$platform_wsl" == "true" ]]; then
  # precommit on Windows filesystem
  if [ -z "$SKIP" ]; then
    export SKIP="check-executables-have-shebangs"
  else
    export SKIP="check-executables-have-shebangs,$SKIP"
  fi
fi
