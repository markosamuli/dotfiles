#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

if [[ "${platform}" == "linux" ]]; then
    # Default to https://www.passwordstore.org/
    if [ -z "${AWS_VAULT_BACKEND}" ]; then
        export AWS_VAULT_BACKEND=pass
    fi
    if [[ "${platform_wsl}" == "true" ]]; then
        # Fix "gpg: decryption failed: No secret key" error
        # https://www.krenger.ch/blog/gopass-gpg-decryption-failed-no-secret-key/
        if [ -z "${GPG_TTY}" ]; then
            GPG_TTY=$(tty)
            export GPG_TTY
        fi
    fi
fi

aws_vault_prompt_precmd() {
    local cloud=$emoji[cloud]
    if [[ -n "$AWS_VAULT" ]]; then
        PROMPT='%F{cyan}'"$cloud ${AWS_VAULT:-}"'%f '$PROMPT
    fi
}

if command -v aws-vault >/dev/null; then
    autoload -U add-zsh-hook
    add-zsh-hook precmd aws_vault_prompt_precmd
fi
