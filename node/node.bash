#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Only one Node.js version manager should be active in a shell at a time,
# otherwise their PATH/hook setup fights each other. Prefer nvm when it's
# installed and fall back to fnm otherwise.
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1090,SC1091
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
elif [ -d "$HOME/.local/share/fnm" ] || command -v fnm >/dev/null; then
    # the fnm install script installs the binary into ~/.local/share/fnm by default
    if [ -d "$HOME/.local/share/fnm" ]; then
        export PATH="$HOME/.local/share/fnm:$PATH"
    fi

    if command -v fnm >/dev/null; then
        eval "$(fnm env --use-on-cd --shell bash)"
    fi
fi
