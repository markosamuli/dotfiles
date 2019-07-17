#!/usr/bin/env bash

if [[ "$platform" == "linux" ]]; then
  export AWS_VAULT_BACKEND=pass
fi
