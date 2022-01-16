#!/bin/zsh

if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -d "${HOME}/.pyenv" ]; then
  if [ -z "${PYENV_ROOT}" ]; then  # do not initialise multiple times
    if ! command -v pyenv >/dev/null; then  # pyenv needs to be added to path on Linux
      export PYENV_ROOT="${HOME}/.pyenv"
      export PATH="${PYENV_ROOT}/bin:${PATH}"
    fi
  fi
  eval "$(pyenv init --path)" # adds PATH only, doesn't set PYENV_ROOT variable
fi
