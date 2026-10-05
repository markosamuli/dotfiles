# Runs for every zsh, including non-interactive ones, so keep this to
# environment setup that scripts and background processes also need.
# Tool modules are loaded here only when they must be on PATH that early.

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Reuse the PATH logic from the module instead of duplicating it.
if [ -f "${DOTFILES:-$HOME/.dotfiles}/bun/path.zsh" ]; then
    . "${DOTFILES:-$HOME/.dotfiles}/bun/path.zsh"
fi
