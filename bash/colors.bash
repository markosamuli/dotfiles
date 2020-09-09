#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# enable color support of ls and also add handy aliases
# shellcheck disable=SC2154
if [[ "${platform}" == "linux" ]]; then
    # enable color support of ls and also add handy aliases
    if [ -x /usr/bin/dircolors ]; then
        if test -r ~/.dircolors; then
            eval "$(dircolors -b ~/.dircolors)"
        else
            eval "$(dircolors -b)"
        fi
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    fi
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
