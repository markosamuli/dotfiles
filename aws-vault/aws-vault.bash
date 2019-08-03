#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

if [[ "$platform" == "linux" ]]; then
  # Default to https://www.passwordstore.org/
  if [ -z "${AWS_VAULT_BACKEND}" ]; then
    export AWS_VAULT_BACKEND=pass
  fi  
  if [[ "$platform_wsl" == "true" ]]; then
    # Fix "gpg: decryption failed: No secret key" error
    # https://www.krenger.ch/blog/gopass-gpg-decryption-failed-no-secret-key/
    if [ -z "${GPG_TTY}" ]; then
      export GPG_TTY=$(tty)
    fi
  fi
fi
