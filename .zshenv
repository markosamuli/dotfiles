if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

if [ -f "${DOTFILES:-$HOME/.dotfiles}/bun/path.zsh" ]; then
    . "${DOTFILES:-$HOME/.dotfiles}/bun/path.zsh"
fi
