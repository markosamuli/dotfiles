#!/bin/zsh

if [[ "$platform" == "linux" ]]; then
  export AWS_VAULT_BACKEND=pass
fi
