#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# Preferred editor for local and remote sessions, default to vim
export EDITOR='vim'
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
elif [[ "$platform" == "linux" ]]; then
  command -v gvim 1>/dev/null 2>&1 && export EDITOR='gvim'
elif [[ "$platform" == "macos" ]]; then
  command -v mvim 1>/dev/null 2>&1 && export EDITOR='mvim'
fi
