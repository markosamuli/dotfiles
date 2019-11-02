#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# do not load if using oh-my-zsh
if [[ "$OH_MY_ZSH" != "true" ]]; then

    # https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/theme-and-appearance.zsh

    # ls colors
    autoload -U colors && colors

    # Enable ls colors
    export LSCOLORS="Gxfxcxdxbxegedabagacad"

    # TODO organise this chaotic logic

    if [[ "$DISABLE_LS_COLORS" != "true" ]]; then
        # Find the option for using colors in ls, depending on the version
        if [[ "$OSTYPE" == darwin* ]]; then
            # this is a good alias, it works by default just using $LSCOLORS
            ls -G . &>/dev/null && alias ls='ls -G'

            # only use coreutils ls if there is a dircolors customization present ($LS_COLORS or .dircolors file)
            # otherwise, gls will use the default color scheme which is ugly af
            if [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]]; then
                gls --color -d . &>/dev/null && alias ls='gls --color=tty'
            fi
        else
            # For GNU ls, we use the default ls color theme. They can later be overwritten by themes.
            if [[ -z "$LS_COLORS" ]]; then
                if (( $+commands[dircolors] )); then
                    eval "$(dircolors -b)"
                fi
            fi

            ls --color -d . &>/dev/null && alias ls='ls --color=tty' || \
                { ls -G . &>/dev/null && alias ls='ls -G' }

            # Take advantage of $LS_COLORS for completion as well.
            zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
        fi
    fi
fi
