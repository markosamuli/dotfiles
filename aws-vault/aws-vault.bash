#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

if [[ "$platform" == "linux" ]]; then
  export AWS_VAULT_BACKEND=pass
fi
