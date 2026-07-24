#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# Only one Node.js version manager should be active in a shell at a time,
# otherwise their chpwd/PATH hooks fight each other. Prefer nvm when it's
# installed and fall back to fnm otherwise.
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"

    if command -v nvm >/dev/null; then
        autoload -U add-zsh-hook
        load-nvmrc() {
            local node_version
            local nvmrc_path
            local nvmrc_node_version
            node_version="$(nvm version)"
            nvmrc_path="$(nvm_find_nvmrc)"

            if [ -n "$nvmrc_path" ]; then
                nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
                if [ "$nvmrc_node_version" = "N/A" ]; then
                    nvm install
                elif [ "$nvmrc_node_version" != "$node_version" ]; then
                    nvm use
                fi
            elif [ "$node_version" != "$(nvm version default)" ]; then
                echo "Reverting to nvm default version"
                nvm use default
            fi
        }
        add-zsh-hook chpwd load-nvmrc
        load-nvmrc
    fi
elif [ -d "$HOME/.local/share/fnm" ] || command -v fnm >/dev/null; then
    # the fnm install script installs the binary into ~/.local/share/fnm by default
    if [ -d "$HOME/.local/share/fnm" ]; then
        export PATH="$HOME/.local/share/fnm:$PATH"
    fi

    if command -v fnm >/dev/null; then
        eval "$(fnm env --use-on-cd --shell zsh)"
    fi
fi
