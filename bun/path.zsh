#!/bin/zsh

# bun is also loaded from .zshenv so non-interactive processes can find it
if [ -d "$HOME/.bun/bin" ]; then
    export BUN_INSTALL="$HOME/.bun"
    case ":$PATH:" in
        *":$BUN_INSTALL/bin:"*) ;;
        *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
    esac
fi
