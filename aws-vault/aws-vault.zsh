#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

if [[ "$platform" == "linux" ]]; then
  if [ -z "${AWS_VAULT_BACKEND}" ]; then
    export AWS_VAULT_BACKEND=pass
  fi
fi

aws_vault_prompt_precmd() {
  if [[ -n "$AWS_VAULT" ]]; then
    PROMPT="%F{cyan}${AWS_VAULT:-}%f "$PROMPT
  fi
}

add-zsh-hook precmd aws_vault_prompt_precmd
