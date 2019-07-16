#!/bin/zsh

if [ -e "${HOME}/.aws-tools/bin/aws_completer" ]; then
  source "${HOME}/.aws-tools/venv/bin/aws_zsh_completer.sh"
fi
