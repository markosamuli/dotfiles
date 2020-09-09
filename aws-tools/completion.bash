#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

if [ -e "${HOME}/.aws-tools/bin/aws_completer" ]; then
    # shellcheck disable=SC1090
    source "${HOME}/.aws-tools/venv/bin/aws_bash_completer"
fi
