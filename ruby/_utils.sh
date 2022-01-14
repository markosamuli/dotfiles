#!/bin/sh

_dotfiles_ruby() {
    # Use rbenv
    if [ -d "${HOME}/.rbenv" ]; then
        _dotfiles_init_rbenv
        return 0
    fi

    # Use ruby from Homebrew
    _dotfiles_add_ruby_from_homebrew_to_path

    # Configure custom RubyGems enviroment
    _dotfiles_custom_rubygems
}

_dotfiles_init_rbenv() {
    # Initialise rbenv only once
    if [ -z "${RBENV_ROOT}" ]; then
        export RBENV_ROOT="${HOME}/.rbenv"
        export PATH="${RBENV_ROOT}/bin:${PATH}"
        eval "$(rbenv init -)"
    fi
}

_dotfiles_add_ruby_from_homebrew_to_path() {
    if ! command -v brew >/dev/null; then
        return 0
    fi
    # shellcheck disable=SC3043
    local ruby_prefix
    ruby_prefix=$(brew --prefix ruby)
    if [ -n "${ruby_prefix}" ] && [ -d "${ruby_prefix}" ]; then
        export PATH="${ruby_prefix}/bin:$PATH"
    fi
}

_dotfiles_custom_rubygems() {
    # Configure custom RubyGems enviroment
    export GEM_HOME="${HOME}/.gem"
    export PATH="${GEM_HOME}/bin:${PATH}"
}
