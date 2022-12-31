#!/usr/bin/env bash

# Auto-completion
# ---------------
if [ -d "/usr/local/opt/fzf" ]; then
    # shellcheck disable=SC1091
    [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null
fi
