#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# the fnm install script installs the binary into ~/.local/share/fnm by default
if [ -d "$HOME/.local/share/fnm" ]; then
    export PATH="$HOME/.local/share/fnm:$PATH"
fi

# load fnm if installed (e.g. via Homebrew or the install script)
if command -v fnm >/dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi
