#!/usr/bin/env bash

if [ -d "$HOME/.bun/bin" ]; then
    export BUN_INSTALL="$HOME/.bun"
    case ":$PATH:" in
        *":$BUN_INSTALL/bin:"*) ;;
        *) export PATH="$BUN_INSTALL/bin:$PATH" ;;
    esac
fi
