#!/usr/bin/env bash

if [ -e "${HOME}/.aws-tools/bin/aws_completer" ]; then
  source "${HOME}/.aws-tools/venv/bin/aws_bash_completer"
fi
