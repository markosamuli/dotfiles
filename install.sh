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
        command -v zsh 1>/dev/null 2>&1 && return 0
        echo "Unsupported OS or distribution: $(uname -s)"
        echo "zsh is not installed."
        exit 1
    fi
}

# Get latest antibody version from GitHub
latest_antibody_version() {
    local latest_release=""
    local errmsg="Failed to get latest antibody release"
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
    if [ ! -d "$DOTFILES" ]; then
        echo "*** Cloning dotfiles from GitHub..."
        git clone $DOTFILES_REPO $DOTFILES
    fi
}

# Install antibody with Homebrew on macOS
install_antibody_with_homebrew() {
    echo "*** Installing antibody with Homebrew..."
    brew install getantibody/tap/antibody
}

# Install antibody using installer on other distributions
install_antibody_with_installer() {
    echo "*** Installing antibody with the installer..."
    command -v curl 1>/dev/null 2>&1 || {
        echo "cURL not installed."
        exit 1
    }
    curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
}

# Install antibody if the binary is not found
install_antibody() {

    command -v antibody 1>/dev/null 2>&1 && return 0

    echo "antibody is not installed."
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "Skipping antibody setup."
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

    echo "Latest antibody version: ${latest_version}"
    echo "Installed antibody version: ${installed_version}"
    read -r -p "Do you want to upgrade? [y/N] " response

    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "Skipping antibody upgrade."
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
        echo "Unsupported OS or distribution: $(uname -s)"
        echo "zsh is not installed."
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

    echo "Homebrew zsh is not installed."
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "Skipping zsh setup."
            return 0
            ;;
    esac

    command -v brew 1>/dev/null 2>&1 || {
        echo "Homebrew not installed."
        exit 1
    }
    echo "*** Installing zsh with Homebrew..."
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
        echo "Unsupported OS or distribution: $(uname -s)"
        echo "zsh is not installed."
        exit 1
    fi
}

# Install zsh using APT on Debian-based distributions
install_zsh_debian() {

    command -v zsh 1>/dev/null 2>&1 && return 0

    echo "zsh is not installed."
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "Skipping zsh setup."
            return 0
            ;;
    esac

    echo "*** Installing zsh..."
    sudo apt-get install zsh
}

# Install Homebrew on macOS
install_homebrew() {

    if [ "$(uname -s)" != "Darwin" ]; then
        return 0
    fi

    command -v brew 1>/dev/null 2>&1 && return 0

    echo "Homebrew not installed."
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS] | [yY]) ;;
        *)
            echo "Skipping Homebrew setup."
            return 0
            ;;
    esac

    echo "*** Installing Homebrew..."
    ruby -e "$(curl -fsSL ${HOMEBREW_INSTALL})" ||
    {
        echo "Failed to install Homebrew"
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
        echo "antibody is not installed."
        exit 1
    }

    if [ ! -d $DOTFILES/antibody ]; then
        echo "$DOTFILES/antibody does not exist"
        return 1
    fi

    if [ -e "$HOME/.bundles.txt" ]; then
        echo "*** Update antibody ~/.bundles.txt..."
    else
        echo "*** Create antibody ~/.bundles.txt..."
    fi
    antibody bundle <"$DOTFILES/antibody/bundles.txt" > ~/.bundles.txt
    antibody bundle sindresorhus/pure >> ~/.bundles.txt
    antibody bundle <"$DOTFILES/antibody/last_bundles.txt" >> ~/.bundles.txt
}

# Setup zsh as the default shell
setup_zsh() {
    local ushell
    command -v zsh 1>/dev/null 2>&1 || {
        echo "zsh is not installed."
        exit 1
    }
    local zsh_bin
    zsh_bin=$(which zsh)
    if [ "$zsh_bin" == "/usr/local/bin/zsh" ]; then
        grep -q $zsh_bin /etc/shells || {
            echo "*** Adding $zsh_bin to /etc/shells..."
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

    echo "*** Updating user shell to $zsh_bin..."
    chsh -s $zsh_bin
}

# Setup a dotfile symlink
setup_dotfile() {
    local dotfile=$1
    if [ -h "$HOME/$dotfile" ]; then
        return 0
    fi
    if [ -e "$HOME/$dotfile" ]; then
        echo "WARNING: ~/$dotfile already exists, skipping symlink setup."
        return 1
    fi
    echo "*** Creating symlink ~/$dotfile -> $DOTFILES/$dotfile"
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
    echo "*** Moving ~/$dotfile -> ~/$dotfile.$timestamp"
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
        ~/.cache
        ~/.ssh
    )
    for dir in "${user_only_directories[@]}"; do
        if [ -d "$dir" ]; then
            echo "*** Fix permissions in $dir..."
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
    if [ "$(uname -s)" != "Darwin" ]; then
        return 0
    fi
    if [ ! -e "/Applications/Hammerspoon.app" ]; then
        return 0
    fi
    if [ ! -d "~/.hammerspoon" ]; then
        mkdir -p ~/.hammerspoon
    fi
    setup_dotfile .hammerspoon/init.lua
}

setup_gitconfig() {
    local gitconfig="${DOTFILES}/.gitconfig"
    local gitconfig_include
    gitconfig_include=$(git config --global --get include.path)
    if [ -z "${gitconfig_include}" ]; then
        echo "*** Include ${DOTFILES}/.gitconfig in ~/.gitconfig"
        git config --global --type path include.path "${gitconfig}"
    fi
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
