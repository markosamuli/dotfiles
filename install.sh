#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

DOTFILES_REPO=https://github.com/markosamuli/dotfiles.git
DOTFILES=$HOME/.dotfiles

GITHUB_RAW=https://raw.githubusercontent.com
HOMEBREW_INSTALL=${GITHUB_RAW}/Homebrew/install/master/install

# Print error into STDERR
error() {
    echo "$@" 1>&2
}

# Install Vim using OS package manager
install_vim() {
    command -v vim 1>/dev/null 2>&1 && return 0
    if [ "$(uname -s)" == "Darwin" ]; then
        brew install vim
    else
        error "[vim] FAILED: vim is not installed."
        error "[vim] Unsupported OS or distribution: $(uname -s)"
        exit 1
    fi
}

# Get latest antibody version from GitHub
latest_antibody_version() {
    local latest_release=""
    local errmsg="[antibody] ERROR: Couldn't get latest antibody release version."
    latest_release=$(get_latest_release getantibody/antibody)
    [ -z "${latest_release}" ] && { error "${errmsg}"; return 1; }
    echo "${latest_release/v/}"
}

# Get installed antibody version
installed_antibody_version() {
    local version=""
    command -v antibody 1>/dev/null 2>&1 || return 1
    version=$(antibody -v 2>&1 | grep 'antibody version' | awk '{ print $3 }')
    echo ${version/v/}
}

# Get latest release for a GitHub repository
get_latest_release() {
    local repository=$1
    local url="https://api.github.com/repos/${repository}/releases/latest"
    if [ ! -z "$GITHUB_OAUTH_TOKEN" ]; then
        url="${url}?access_token=${GITHUB_OAUTH_TOKEN}"
    fi
    curl --silent "${url}" | \
        grep '"tag_name":' | \
        sed -E 's/.*"([^"]+)".*/\1/'
}

# Download dotfiles if the local directory does not exist
download_dotfiles() {
    command -v git >/dev/null || {
        error "[dotfiles] FAILED: Git is not installed."
        exit 1
    }
    if [ ! -d "$DOTFILES" ]; then
        echo "[dotfiles] Cloning dotfiles from GitHub..."
        git clone $DOTFILES_REPO $DOTFILES || {
            error "[dotfiles] FAILED: Something went wrong while cloding $DOTFILES_REPO repository."
            exit 1
        }
    fi
}

# Install antibody with Homebrew on macOS
install_antibody_with_homebrew() {
    echo "[antibody] Installing antibody with Homebrew..."
    brew install getantibody/tap/antibody
}

# Install antibody using installer on other distributions
install_antibody_with_installer() {
    echo "[antibody] Installing antibody with the installer..."
    command -v curl 1>/dev/null 2>&1 || {
        error "[antibody] FAILED: cURL is not installed"
        exit 1
    }
    curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
}

# Install antibody if the binary is not found
install_antibody() {

    command -v antibody 1>/dev/null 2>&1 && return 0

    echo "[antibody] antibody is not installed"
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "[antibody] Skipping antibody setup."
            return 0
            ;;
    esac

    if [ "$(uname -s)" == "Darwin" ]; then
        install_antibody_with_homebrew
    else
        install_antibody_with_installer
    fi
}

# Update antibody if we don't have the latest version
update_antibody() {

    local latest_version
    latest_version=$(latest_antibody_version)
    installed_version=$(installed_antibody_version)
    if [ "${latest_version}" == "${installed_version}" ]; then
        return 0
    fi

    echo "[antibody] Latest antibody version: ${latest_version}"
    echo "[antibody] Installed antibody version: ${installed_version}"
    read -r -p "Do you want to upgrade? [y/N] " response

    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "[antibody] Skipping antibody upgrade."
            return 0
            ;;
    esac

    if [ "$(uname -s)" == "Darwin" ]; then
        install_antibody_with_homebrew
    else
        install_antibody_with_installer
    fi
}

# Install zsh
install_zsh() {
    if [ "$(uname -s)" == "Darwin" ]; then
        install_zsh_darwin
    elif [ "$(uname -s)" == "Linux" ]; then
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
    if [ "$zsh_bin" == "/usr/local/bin/zsh" ]; then
        return 0
    fi

    echo "[zsh] zsh is not installed from Homebrew"
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "[zsh] skipping zsh setup"
            return 0
            ;;
    esac

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
        distrib_id=$(cat /etc/lsb-release | grep DISTRIB_ID= | cut -d= -f2)
        echo "${distrib_id}" | awk '{print tolower($0)}'
    elif [ -e "/etc/os-release" ]; then
        id=$(cat /etc/os-release | grep ID= | cut -d= -f2)
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

    echo "[zsh] zsh is not installed"
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "[zsh] Skipping zsh setup."
            return 0
            ;;
    esac

    echo "[zsh] Installing zsh..."
    sudo apt-get install zsh
}

# Install Homebrew on macOS
install_homebrew() {

    if [ "$(uname -s)" != "Darwin" ]; then
        return 0
    fi

    command -v brew 1>/dev/null 2>&1 && return 0

    echo "[homebrew] Homebrew not installed"
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "[homebrew] Skipping Homebrew setup."
            return 0
            ;;
    esac

    echo "[homebrew] Installing Homebrew..."
    ruby -e "$(curl -fsSL ${HOMEBREW_INSTALL})" ||
    {
        error "[homebrew] FAILED: Something went wrong while installing Homebrew."
        exit 1
    }

}

# Get current antibody version
antibody_version() {
    command -v antibody 1>/dev/null 2>&1 || return 1
    antibody --version | awk '{print $3}'
}

# Create or update antibody ~/.bundles.txt file
setup_antibody() {

    command -v antibody 1>/dev/null 2>&1 || {
        error "[antibody] FAILED: antibody is not installed"
        exit 1
    }

    if [ ! -d $DOTFILES/antibody ]; then
        error "[antibody] FAILED: $DOTFILES/antibody does not exist"
        return 1
    fi

    if [ -e "$HOME/.bundles.txt" ]; then
        echo "[antibody] Updating ~/.bundles.txt..."
    else
        echo "[antibody] Creating ~/.bundles.txt..."
    fi
    antibody bundle <"$DOTFILES/antibody/bundles.txt" > ~/.bundles.txt
    antibody bundle sindresorhus/pure >> ~/.bundles.txt
    antibody bundle <"$DOTFILES/antibody/last_bundles.txt" >> ~/.bundles.txt
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
    if [ "$zsh_bin" == "/usr/local/bin/zsh" ]; then
        grep -q $zsh_bin /etc/shells || {
            echo "[zsh] Adding $zsh_bin to /etc/shells..."
            sudo sh -c "echo $zsh_bin >> /etc/shells"
        }
    fi
    if [ "$(uname -s)" == "Linux" ]; then
        ushell=$(getent passwd $LOGNAME | cut -d: -f7)
        [ "$ushell" == "$zsh_bin" ] && return 0
    else
        ushell=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
        [ "$ushell" == "$zsh_bin" ] && return 0
    fi

    echo "[zsh] Updating user default shell to $zsh_bin..."
    chsh -s $zsh_bin
}

# Setup a dotfile symlink
setup_dotfile() {
    local dotfile=$1
    if [ -h "$HOME/$dotfile" ]; then
        return 0
    fi
    if [ -e "$HOME/$dotfile" ]; then
        echo "[dotfiles] WARNING: ~/$dotfile already exists, skipping symlink setup"
        return 1
    fi
    echo "[dotfiles] Creating symlink ~/$dotfile -> $DOTFILES/$dotfile"
    ln -s $DOTFILES/$dotfile ~/$dotfile
}

# Backup dotfile before creating symlink
backup_dotfile() {
    local dotfile=$1
    local timestamp
    if [ -h "$HOME/$dotfile" ]; then
        return 0
    fi
    if [ ! -e "$HOME/$dotfile" ]; then
        return 0
    fi
    timestamp=$(date +"%Y%m%d%H%M%S")
    echo "[dotfiles] Moving ~/$dotfile -> ~/$dotfile.$timestamp"
    mv ~/$dotfile ~/$dotfile.$timestamp
}

# Setup .tmux.conf symlink if tmux is installed
setup_tmux() {
    command -v tmux 1>/dev/null 2>&1 || return 0
    setup_dotfile .tmux.conf
}

# Fix permissions
fix_permissions() {
    user_only_directories=(
        $DOTFILES
        ~/.cache/antibody
        ~/.cache/Homebrew
        ~/.ssh
    )
    for dir in "${user_only_directories[@]}"; do
        if [ -d "$dir" ]; then
            echo "[permissions] Set permissions in user only directory $dir"
            chmod -R og-rwx $dir
        fi
    done
}

# Setup symlinks to dotfiles
setup_dotfile_symlinks() {
    dotfile_symlinks=(
        .aliases
        .zshrc
        .bashrc
        .gitignore_global
        .editorconfig
        .markdownlintrc
    )
    for file in "${dotfile_symlinks[@]}"; do
        backup_dotfile $file
        setup_dotfile $file
    done
}

# Setup symlink to Hammerspoon configuration if installed
setup_hammerspoon() {
    local hammerspoon_dir="~/.hammerspoon"
    if [ "$(uname -s)" != "Darwin" ]; then
        return 0
    fi
    if [ ! -e "/Applications/Hammerspoon.app" ]; then
        return 0
    fi
    echo "[hammerspoon] Hammerspoon installed, adding configuration..."
    if [ ! -d "${hammerspoon_dir}" ]; then
        mkdir -p ${hammerspoon_dir} || {
            error "[hammerspoon] FAILED: Couldn't create ${hammerspoon_dir} directory."
        }
    fi
    setup_dotfile .hammerspoon/init.lua
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
}

setup_vim() {
    local vim_autoload="$HOME/.vim/autoload"
    local vim_plugged="$HOME/.vim/plugged"
    local vim_plug="https://raw.github.com/junegunn/vim-plug/master/plug.vim"
    if [ ! -d "${vim_autoload}" ]; then
        echo "[vim] Create ${vim_autoload} directory"
        mkdir -p ${vim_autoload} || {
            error "[vim] FAILED: couldn't create ${vim_autoload} directory"
            return 1
        }
    fi
    if [ ! -d "${vim_plugged}" ]; then
        echo "[vim] Create ${vim_plugged} plugin directory"
        mkdir -p ${vim_plugged} || {
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
    if (( ${installed[0]} < ${required[0]} )); then
        return 1
    fi
    # shellcheck disable=SC2004
    if (( ${installed[1]} < ${required[1]} )); then
        return 1
    fi
    return 0
}

# Clone dotfiles
download_dotfiles

# Install requirements
install_homebrew
install_zsh
install_antibody
install_vim

# Update requirements
update_antibody

# Configure zsh
setup_zsh
setup_antibody

# Configure vim
setup_vim

# Setup dotfile symlinks
setup_dotfile_symlinks

# Setup tmux config if installed
setup_tmux

# Setup Hammerspoon configuration
setup_hammerspoon

# Setup Git to include .gitconfig from .dotfiles
setup_gitconfig

# Fix permissions
fix_permissions
