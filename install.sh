#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

DOTFILES_REPO=https://github.com/markosamuli/dotfiles.git
DOTFILES=$HOME/.dotfiles

HOMEBREW_INSTALL=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

error() {
    echo "$@" 1>&2
}

configure_install() {
    if [ -n "${PS1}" ]; then
        INTERACTIVE=true
    elif tty -s; then
        INTERACTIVE=true
    fi
    if [ -z "${INTERACTIVE}" ]; then
        INSTALL_HOMEBREW=${INSTALL_HOMEBREW:-true}
        INSTALL_ZSH=${INSTALL_ZSH:-true}
        INSTALL_SHELDON=${INSTALL_SHELDON:-true}
        INSTALL_GITHUB_CLI=${INSTALL_GITHUB_CLI:-true}
        UPDATE_ZSH=false
    else
        UPDATE_ZSH=true
    fi
}

# Install Vim using OS package manager
install_vim() {
    command -v vim 1>/dev/null 2>&1 && return 0
    local os
    os="$(uname -s)"
    if [ "${os}" == "Darwin" ]; then
        if ! brew install vim; then
            error "[vim] FAILED: brew install vim"
            exit 1
        fi
        return 0
    elif [ "${os}" == "Linux" ]; then
        local distrib
        distrib=$(linux_distrib)
        if [ "${distrib}" == "ubuntu" ] || [ "${distrib}" == "debian" ]; then
            if ! sudo apt-get install -y vim; then
                error "[vim] FAILED: apt-get install vim"
                exit 1
            fi
            return 0
        else
            error "[vim] Unsupported distribution: ${distrib}"
        fi
    else
        error "[vim] Unsupported OS: ${os}"
    fi
    error "[vim] FAILED: vim is not installed."
    exit 1
}

# Get latest release for a GitHub repository
get_latest_release() {
    local repository=$1
    local url="https://api.github.com/repos/${repository}/releases/latest"
    if [ -n "$GITHUB_OAUTH_TOKEN" ]; then
        url="${url}?access_token=${GITHUB_OAUTH_TOKEN}"
    fi
    curl --silent "${url}" |
        grep '"tag_name":' |
        sed -E 's/.*"([^"]+)".*/\1/'
}

# Download dotfiles if the local directory does not exist
download_dotfiles() {
    if [ -d "$DOTFILES" ]; then
        return 0
    fi
    command -v git >/dev/null || {
        error "[dotfiles] FAILED: Git is not installed."
        exit 1
    }
    if [ ! -d "${DOTFILES}" ]; then
        echo "[dotfiles] Cloning dotfiles from GitHub..."
        git clone --recurse-submodules "${DOTFILES_REPO}" "${DOTFILES}" || {
            error "[dotfiles] FAILED: Something went wrong while cloning ${DOTFILES_REPO} repository."
            exit 1
        }
    fi
}

init_local_bin_path() {
    if [ ! -d "${HOME}/.local/bin" ]; then
        return 0
    fi
    if [[ "${PATH}" =~ "${HOME}/.local/bin" ]]; then
        return 0
    fi
    PATH="${HOME}/.local/bin:${PATH}"
}

install_sheldon() {

    init_local_bin_path

    command -v sheldon 1>/dev/null 2>&1 && return 0

    echo "[sheldon] sheldon is not installed"

    install_prompt "sheldon" "${INSTALL_SHELDON}" "sheldon" || return 0

    if [ "$(uname -s)" == "Darwin" ]; then
        install_sheldon_with_homebrew
    elif [[ $(uname -s) == 'Linux' ]]; then
        install_sheldon_with_installer
    else
        error "[sheldon] Unsupported OS or distribution: $(uname -s)"
        return 1
    fi
}

install_sheldon_with_homebrew() {
    echo "[sheldon] Installing sheldon with Homebrew..."
    brew install sheldon
}

install_sheldon_with_installer() {
    echo "[sheldon] Installing sheldon with the installer..."
    command -v curl 1>/dev/null 2>&1 || {
        error "[sheldon] FAILED: cURL is not installed"
        exit 1
    }
    curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
        | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
}

# Install zsh
install_zsh() {
    if [[ $(uname -s) == 'Darwin' ]]; then
        install_zsh_darwin
    elif [[ $(uname -s) == 'Linux' ]]; then
        install_zsh_linux
    else
        command -v zsh 1>/dev/null 2>&1 && return 0
        error "[zsh] FAILED: zsh is not installed"
        error "[zsh] Unsupported OS or distribution: $(uname -s)"
        exit 1
    fi
}

# Install zsh from Homebrew on macOS
install_zsh_darwin() {
    local zsh_bin
    zsh_bin=$(which zsh)
    if [[ -n "${HOMEBREW_PREFIX}" ]] && [[ "$zsh_bin" == "${HOMEBREW_PREFIX}/bin/zsh" ]]; then
        return 0
    elif [ "$zsh_bin" == "/usr/local/bin/zsh" ]; then
        return 0
    fi

    install_prompt "zsh" "${INSTALL_ZSH}" "zsh from Homebrew" || return 0

    command -v brew 1>/dev/null 2>&1 || {
        error "[zsh] FAILED: Homebrew not installed."
        exit 1
    }

    echo "[zsh] Installing zsh with Homebrew..."
    brew install zsh
}

# Get Linux distribution ID
linux_distrib() {
    local id
    local distrib_id
    if [ -e "/etc/lsb-release" ]; then
        distrib_id=$(grep DISTRIB_ID= /etc/lsb-release | cut -d= -f2)
        echo "${distrib_id}" | awk '{print tolower($0)}'
    elif [ -e "/etc/os-release" ]; then
        id=$(grep '^ID=' /etc/os-release | cut -d= -f2)
        echo "${id}"
    fi
}

# Install zsh on Linux using OS package manager
install_zsh_linux() {
    local distrib
    distrib=$(linux_distrib)
    if [ "${distrib}" == "ubuntu" ]; then
        install_zsh_debian
    elif [ "${distrib}" == "debian" ]; then
        install_zsh_debian
    else
        command -v zsh 1>/dev/null 2>&1 && return 0
        error "[zsh] FAILED: zsh is not installed"
        error "[zsh] Unsupported Linux distribution: ${distrib}"
        exit 1
    fi
}

# Install zsh using APT on Debian-based distributions
install_zsh_debian() {

    command -v zsh 1>/dev/null 2>&1 && return 0

    install_prompt "zsh" "${INSTALL_ZSH}" "zsh" || return 0

    echo "[zsh] Installing zsh..."
    sudo apt-get install -y zsh
}

# Install Homebrew on macOS
install_homebrew() {

    if [ "$(uname -s)" != "Darwin" ]; then
        return 0
    fi

    command -v brew 1>/dev/null 2>&1 && return 0

    if [[ $(uname -m) == 'arm64' ]] && [[ -d "/opt/homebrew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)" && return 0
    fi

    install_prompt "homebrew" "${INSTALL_HOMEBREW}" "Homebrew" || return 0

    echo "[homebrew] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL ${HOMEBREW_INSTALL})" ||
        {
            error "[homebrew] FAILED: Something went wrong while installing Homebrew."
            exit 1
        }

}

install_prompt() {
    local prefix=$1
    local enabled=$2
    local name=$3
    if [ -z "${enabled}" ]; then
        read -r -p "[${prefix}] ${name} is not installed. Do you want to install it now? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                echo "[${prefix}] Skip ${name} installation"
                return 1
                ;;
        esac
    elif [ "${enabled}" != "true" ]; then
        echo "[${prefix}] Skip ${name} installation"
        return 1
    fi
}

install_github_cli() {

    command -v gh 1>/dev/null 2>&1 && return 0

    install_prompt "gh" "${INSTALL_GITHUB_CLI}" "GitHub CLI" || return 0

    if [[ $(uname -s) == 'Darwin' ]]; then
        install_github_cli_macos
    elif [[ $(uname -s) == 'Linux' ]]; then
        install_github_cli_linux
    else
        error "[gh] Unsupported OS or distribution: $(uname -s)"
        exit 1
    fi
}


install_github_cli_macos() {
    command -v brew 1>/dev/null 2>&1 || {
        error "[gh] FAILED: Homebrew not installed."
        exit 1
    }
    echo "[gh] Installing GitHub CLI with Homebrew..."
    brew install gh
}

install_github_cli_linux() {
    local distrib
    distrib=$(linux_distrib)
    if [ "${distrib}" == "ubuntu" ] || [ "${distrib}" == "debian" ]; then
        install_github_cli_apt
    else
        error "[zsh] Unsupported OS or distribution: $(uname -s)"
        exit 1
    fi
}

install_github_cli_apt() {
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
}

setup_sheldon() {

    init_local_bin_path

    command -v sheldon 1>/dev/null 2>&1 || {
        error "[sheldon] FAILED: sheldon is not installed"
        exit 1
    }

    local xdg_config_user
    xdg_config_user="${XDG_CONFIG_HOME:-$HOME/.config}"

    local sheldon_config
    if [ -d "${xdg_config_user}" ]; then
        sheldon_config="${xdg_config_user}/sheldon"
    else
        sheldon_config="${HOME}/.sheldon"
    fi

    echo "Using ${sheldon_config}"

    if [ ! -d "${sheldon_config}" ]; then
        mkdir -p "${sheldon_config}"
    fi

    local sheldon_plugins
    sheldon_plugins="${sheldon_config}/plugins.toml"
    if [ ! -e "${sheldon_plugins}" ]; then
        echo "[sheldon] Creating ${sheldon_plugins/$HOME/~} symlink"
        ln -s "${DOTFILES}/.config/sheldon/plugins.toml" "${sheldon_plugins}"
    fi
}

# Setup zsh as the default shell
setup_zsh() {
    local ushell
    command -v zsh 1>/dev/null 2>&1 || {
        echo "[zsh] FAILED: zsh is not installed"
        exit 1
    }

    local zsh_bin
    zsh_bin=$(which zsh)
    if [[ -n "${HOMEBREW_PREFIX}" ]] && [[ "$zsh_bin" == "${HOMEBREW_PREFIX}/bin/zsh" ]]; then
        grep -q "${zsh_bin}" /etc/shells || {
            echo "[zsh] Adding ${zsh_bin} to /etc/shells..."
            sudo sh -c "echo ${zsh_bin} >> /etc/shells"
        }
    elif [ "${zsh_bin}" == "/usr/local/bin/zsh" ]; then
        grep -q "${zsh_bin}" /etc/shells || {
            echo "[zsh] Adding ${zsh_bin} to /etc/shells..."
            sudo sh -c "echo ${zsh_bin} >> /etc/shells"
        }
    fi

    if [ "$(uname -s)" == "Linux" ]; then
        ushell=$(getent passwd "${LOGNAME}" | cut -d: -f7)
        [ "${ushell}" == "${zsh_bin}" ] && return 0
    else
        ushell=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
        [ "${ushell}" == "${zsh_bin}" ] && return 0
    fi

    if [ "${UPDATE_ZSH}" == "true" ]; then
        echo "[zsh] Updating user default shell to ${zsh_bin}..."
        chsh -s "${zsh_bin}"
    else
        echo "[zsh] User default shell not set to Zsh"
        INTERACTIVE_INSTALL_REQUIRED=true
    fi
}

# Setup a dotfile symlink
setup_dotfile() {
    local dotfile=$1
    if [ -h "${HOME}/${dotfile}" ]; then
        return 0
    fi
    if [ -e "${HOME}/${dotfile}" ]; then
        echo "[dotfiles] WARNING: ~/${dotfile} already exists, skipping symlink setup"
        return 1
    fi
    echo "[dotfiles] Creating symlink ~/${dotfile} -> ${DOTFILES}/${dotfile}"
    ln -s "${DOTFILES}/${dotfile}" "${HOME}/${dotfile}"
}

# Backup dotfile before creating symlink
backup_dotfile() {
    local dotfile=$1
    local timestamp
    if [ -h "${HOME}/${dotfile}" ]; then
        return 0
    fi
    if [ ! -e "${HOME}/${dotfile}" ]; then
        return 0
    fi
    timestamp=$(date +"%Y%m%d%H%M%S")
    echo "[dotfiles] Moving ~/${dotfile} -> ~/${dotfile}.$timestamp"
    mv "${HOME}/${dotfile}" "${HOME}/${dotfile}.$timestamp"
}

# Setup .tmux.conf symlink if tmux is installed
setup_tmux() {
    command -v tmux 1>/dev/null 2>&1 || return 0
    setup_dotfile .tmux.conf
}

# Fix permissions
fix_permissions() {
    user_only_directories=(
        "${DOTFILES}"s
        ~/.cache/Homebrew
        ~/.ssh
    )
    shell_directories=(
        /usr/local/share/zsh
    )
    for dir in "${user_only_directories[@]}"; do
        if [ -d "${dir}" ]; then
            echo "[permissions] Set permissions in user only directory ${dir}"
            chmod -R og-rwx "${dir}"
        fi
    done
    if [ "$(uname -s)" == "Linux" ]; then
        for dir in "${shell_directories[@]}"; do
            if [ -d "${dir}" ]; then
                echo "[permissions] Set permissions in shell directory ${dir}"
                sudo chmod -R og-w "${dir}"
            fi
        done
    else
        for dir in "${shell_directories[@]}"; do
            if [ -d "$dir" ]; then
                echo "[permissions] Set permissions in shell directory $dir"
                chmod -R og-w "$dir"
            fi
        done
    fi
}

# Setup symlinks to dotfiles
setup_dotfile_symlinks() {
    dotfile_symlinks=(
        .aliases
        .zshrc
        .zprofile
        .bashrc
        .gitignore_global
        .editorconfig
        .markdownlintrc
        .vimrc
    )
    for file in "${dotfile_symlinks[@]}"; do
        backup_dotfile "${file}"
        setup_dotfile "${file}"
    done
}

git_version() {
    local version
    version=$(git --version)
    echo "${version/git version /}"
}

setup_gitconfig() {
    # Include ~/.dotfiles/.gitconfig
    local gitconfig="${DOTFILES}/.gitconfig"
    local gitconfig_include
    gitconfig_include=$(git config --global --get include.path)
    if [ -z "${gitconfig_include}" ]; then
        echo "[git] include.path=${gitconfig}"
        if compare_version "2.18.0" "$(git_version)"; then
            git config --global --type=path include.path "${gitconfig}"
        else
            git config --global --path include.path "${gitconfig}"
        fi
    fi

    # Set ~/.gitignore_global excludes file
    local gitignore_global="${HOME}/.gitignore_global"
    local gitconfig_excludesfile
    gitconfig_excludesfile=$(git config --global --get core.excludesfile)
    if [ -z "${gitconfig_excludesfile}" ]; then
        echo "[git] core.excludesfile=${gitignore_global}"
        if compare_version "2.18.0" "$(git_version)"; then
            git config --global --type=path core.excludesfile "${gitignore_global}"
        else
            git config --global --path core.excludesfile "${gitignore_global}"
        fi
    fi

    # Set ~/.gitcookies file
    local gitcookies="${HOME}/.gitcookies"
    local gitconfig_cookiefile
    gitconfig_cookiefile=$(git config --global --get http.cookiefile)
    if [ -z "${gitconfig_cookiefile}" ]; then
        if [ -e "${gitcookies}" ]; then
            echo "[git] http.cookiefile=${gitcookies}"
            if compare_version "2.18.0" "$(git_version)"; then
                git config --global --type=path http.cookiefile "${gitcookies}"
            else
                git config --global --path http.cookiefile "${gitcookies}"
            fi
        fi
    fi
}

setup_git_difftool() {
    if [[ -n "$CI" ]]; then
        echo '[git] Skip difftool setup on CI'
        return 0
    fi

    local difftools=()

    if command -v ksdiff >/dev/null; then
        difftools+=("ksdiff")

        echo '[git] Add Kaleidoscope (ksdiff) as a git diff tool'
        # shellcheck disable=SC2016
        git config --global difftool.ksdiff.cmd \
            'ksdiff --partial-changeset --relative-path "$MERGED" -- "$LOCAL" "$REMOTE"'

        # Exit difftool if the invoked diff tool returns a non-zero exit status.
        git config --global difftool.ksdiff.trustexitcode 'true'
    fi

    if command -v meld >/dev/null; then
        difftools+=("meld")

        echo '[git] Add meld as a git diff tool'
        # shellcheck disable=SC2016
        git config --global difftool.meld.cmd 'meld "$LOCAL" "$REMOTE"'

        # Exit difftool if the invoked diff tool returns a non-zero exit status.
        git config --global difftool.meld.trustexitcode 'true'
    fi

    # local gitconfig_diff_tool
    # gitconfig_diff_tool=$(git config --global --get diff.tool)
    # if [ -z "${gitconfig_diff_tool}" ]; then
    #     echo "[git] Default diff.tool is not configured."
    #     setup_default_git_diff_tool "${difftools[@]}"
    # fi

    local gitconfig_diff_guitool
    gitconfig_diff_guitool=$(git config --global --get diff.guitool)
    if [ -z "${gitconfig_diff_guitool}" ]; then
        echo "[git] Default diff.guitool is not configured."
        setup_default_git_diff_guitool "${difftools[@]}"
    fi

    # Do not prompt before each invocation of the diff tool.
    git config --global difftool.prompt 'false'
}

setup_default_git_diff_tool() {
    local difftools=("$@")
    for difftool in "${difftools[@]}"; do
        read -r -p "[git] Do you want to use '${difftool}' as diff.tool? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                continue
                ;;
        esac
        echo "[git] diff.tool=${difftool}"
        git config --global diff.tool "${difftool}"
        return 0
    done
    return 1
}

setup_default_git_diff_guitool() {
    local difftools=("$@")
    for difftool in "${difftools[@]}"; do
        read -r -p "[git] Do you want to use '${difftool}' as diff.guitool? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                continue
                ;;
        esac
        echo "[git] diff.guitool=${difftool}"
        git config --global diff.guitool "${difftool}"
        return 0
    done
    return 1
}

setup_git_mergetool() {
    if [[ -n "$CI" ]]; then
        echo '[git] Skip mergetool setup on CI'
        return 0
    fi

    local mergetools=()

    if command -v ksdiff >/dev/null; then
        mergetools+=("ksdiff")

        echo '[git] Add Kaleidoscope (ksdiff) as a git merge tool'
        # shellcheck disable=SC2016
        git config --global mergetool.ksdiff.cmd \
            'ksdiff --merge --output "$MERGED" --base "$BASE" -- "$LOCAL" --snapshot "$REMOTE" --snapshot'

        # Exit mergetool if the invoked merge tool returns a non-zero exit status.
        git config --global mergetool.ksdiff.trustExitCode 'true'
    fi

    if command -v meld >/dev/null; then
        mergetools+=("meld")

        echo '[git] Add meld as a git merge tool'
        # shellcheck disable=SC2016
        git config --global mergetool.meld.cmd \
            'meld --auto-merge "$LOCAL" "$MERGED" "$REMOTE" --output "$MERGED"'

        # Exit mergetool if the invoked merge tool returns a non-zero exit status.
        git config --global mergetool.meld.trustExitCode 'true'
    fi

    # local gitconfig_merge_tool
    # gitconfig_merge_tool=$(git config --global --get merge.tool)
    # if [ -z "${gitconfig_merge_tool}" ]; then
    #     echo "[git] Default merge.tool not configured."
    #     setup_default_git_merge_tool "${mergetools[@]}"
    # fi

    local gitconfig_merge_guitool
    gitconfig_merge_guitool=$(git config --global --get merge.guitool)
    if [ -z "${gitconfig_merge_guitool}" ]; then
        echo "[git] Default merge.guitool not configured."
        setup_default_git_merge_guitool "${mergetools[@]}"
    fi

    # Do not prompt before each invocation of the merge tool.
    git config --global mergetool.prompt 'false'

    # Automatically remove the backup as files are successfully merged.
    git config --global mergetool.keepBackup 'false'
}

setup_default_git_merge_tool() {
    local mergetools=("$@")
    for mergetool in "${mergetools[@]}"; do
        read -r -p "[git] Do you want to use '${mergetool}' as merge.tool? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                continue
                ;;
        esac
        echo "[git] merge.tool=${mergetool}"
        git config --global merge.tool "${mergetool}"
        return 0
    done
    return 1
}

setup_default_git_merge_guitool() {
    local mergetools=("$@")
    for mergetool in "${mergetools[@]}"; do
        read -r -p "[git] Do you want to use '${mergetool}' as merge.guitool? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                continue
                ;;
        esac
        echo "[git] merge.guitool=${mergetool}"
        git config --global merge.guitool "${mergetool}"
        return 0
    done
    return 1
}

setup_git_editor() {
    local editor
    local gitconfig_editor
    gitconfig_editor=$(git config --global --get core.editor)
    if [ -z "${gitconfig_editor}" ]; then
        if command -v vim >/dev/null; then
            editor=$(command -v vim)
        fi
        if [ -n "${editor}" ]; then
            echo "[git] core.editor=${editor}"
            if compare_version "2.18.0" "$(git_version)"; then
                git config --global --type=path core.editor "${editor}"
            else
                git config --global --path core.editor "${editor}"
            fi
        fi
    fi
}

setup_vim() {
    local vim_autoload="$HOME/.vim/autoload"
    local vim_plugged="$HOME/.vim/plugged"
    local vim_plug="https://raw.github.com/junegunn/vim-plug/master/plug.vim"
    if [ ! -d "${vim_autoload}" ]; then
        echo "[vim] Create ${vim_autoload} directory"
        mkdir -p "${vim_autoload}" || {
            error "[vim] FAILED: couldn't create ${vim_autoload} directory"
            return 1
        }
    fi
    if [ ! -d "${vim_plugged}" ]; then
        echo "[vim] Create ${vim_plugged} plugin directory"
        mkdir -p "${vim_plugged}" || {
            error "[vim] FAILED: couldn't create ${vim_plugged} directory"
            return 1
        }
    fi
    if [ ! -e "${vim_autoload}/plug.vim" ]; then
        echo "[vim] Install vim-plug"
        curl -fLo "${vim_autoload}/plug.vim" "${vim_plug}" || {
            error "[vim] FAILED: couldn't download vim-plug"
            return 1
        }
    fi
}

# Compare the major and minor parts of two version strings
# Usage: compare_version <required> <installed>
# Example: compare_version "1.2.0" "1.3.0"
compare_version() {
    local IFS=.
    # shellcheck disable=SC2206
    local required=($1)
    # shellcheck disable=SC2206
    local installed=($2)
    # shellcheck disable=SC2004
    if ((${installed[0]} < ${required[0]})); then
        return 1
    fi
    # shellcheck disable=SC2004
    if ((${installed[1]} < ${required[1]})); then
        return 1
    fi
    return 0
}

# Print instructions if interactive install is required
require_interactive_install() {
    if [ -n "${INTERACTIVE_INSTALL_REQUIRED}" ]; then
        echo ""
        echo "Interactive install required to complete setup."
        echo ""
        echo "Please run the following commands:"
        echo ""
        echo "  cd $DOTFILES"
        echo "  make install"
        echo ""
    fi
}

install_man_pages() {
    local man_dir

    if [[ -n "${HOMEBREW_PREFIX}" ]] && [[ -d "${HOMEBREW_PREFIX}/share/man" ]]; then
        man_dir="${HOMEBREW_PREFIX}/share/man/man1"
    elif [ -d "/usr/local/share/man" ]; then
        man_dir="/usr/local/share/man/man1"
    fi
    if [ -z "${man_dir}" ]; then
        error "[man] FAILED: couldn't find a directory for man pages"
        return 1
    fi
    if [ ! -d "${man_dir}" ]; then
        echo "[man] create ${man_dir}"
        sudo mkdir -p "${man_dir}" || {
            error "[man] FAILED: couldn't create directory ${man_dir}"
            exit 1
        }
    fi
}

install_requirements() {
    install_homebrew
    install_zsh
    install_sheldon
    install_vim
    install_man_pages
    install_github_cli
}

configure_zsh() {
    setup_zsh
    setup_sheldon
}

setup_github() {
    return 0
}

# Configure install script
configure_install

# Clone dotfiles
download_dotfiles

# Install requirements
install_requirements

# Configure zsh
configure_zsh

# Configure vim
setup_vim

# Setup dotfile symlinks
setup_dotfile_symlinks

# Setup tmux config if installed
setup_tmux

# Setup Git to include .gitconfig from .dotfiles
setup_gitconfig
setup_git_editor
setup_git_difftool
setup_git_mergetool

# Setup GitHub configuration
setup_github

# Fix permissions
fix_permissions

# Check if interactive install is required
require_interactive_install
