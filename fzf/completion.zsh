#!/bin/zsh

# Auto-completion
# ---------------
if [ -d "/usr/local/opt/fzf" ]; then
    [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
fi
