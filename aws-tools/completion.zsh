#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

if [ -e "${HOME}/.aws-tools/bin/aws_completer" ]; then
  source "${HOME}/.aws-tools/venv/bin/aws_zsh_completer.sh"
fi
