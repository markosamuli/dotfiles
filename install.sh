#!/usr/bin/env bash

DOTFILES_REPO=https://github.com/markosamuli/dotfiles.git
DOTFILES=$HOME/.dotfiles

function download_dotfiles {
    # Do we need to download the dotfiles?
    if [ ! -d "$DOTFILES" ]; then
        echo "*** Cloning dotfiles from GitHub..."
        git clone $DOTFILES_REPO $DOTFILES
    fi
}

function install_antibody {

    command -v antibody 1>/dev/null 2>&1 && return 0

    echo "antibody is not installed."
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            ;;
        *)
            echo "Skipping antibody setup."
            return 0
            ;;
    esac

    echo "*** Installing antibody..."
    if [ "$(uname -s)" == "Darwin" ]; then
      brew install getantibody/tap/antibody
    else
      command -v curl 1>/dev/null 2>&1 || { echo "cURL not installed."; exit 1; }
      curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
    fi
}

function install_zsh {
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

function install_zsh_darwin {

    local zsh_bin=$(which zsh)
    if [ "$zsh_bin" == "/usr/local/bin/zsh" ]; then
        return 0
    fi

    echo "Homebrew zsh is not installed."
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            ;;
        *)
            echo "Skipping zsh setup."
            return 0
            ;;
    esac

    command -v brew 1>/dev/null 2>&1 || { echo "Homebrew not installed."; exit 1; }
    echo "*** Installing zsh with Homebrew..."
    brew install zsh
}

function linux_distrib {
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

function install_zsh_linux {
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

function install_zsh_debian {

    command -v zsh 1>/dev/null 2>&1 && return 0

    echo "zsh is not installed."
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            ;;
        *)
            echo "Skipping zsh setup."
            return 0
            ;;
    esac

    echo "*** Installing zsh..."
    sudo apt-get install zsh
}

function install_homebrew {

    if [ "$(uname -s)" != "Darwin" ]; then
        return 0
    fi

    command -v brew 1>/dev/null 2>&1 && return 0

    echo "Homebrew not installed."
    read -r -p "Do you want to install it now? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            ;;
        *)
            echo "Skipping Homebrew setup."
            return 0
            ;;
    esac

    echo "*** Installing Homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
        || { echo "Failed to install Homebrew"; exit 1; }

}

function antibody_version {
    command -v antibody 1>/dev/null 2>&1 || return 1
    antibody --version | awk '{print $3}'
}

function setup_antibody {

    command -v antibody 1>/dev/null 2>&1 || { echo "antibody is not installed."; exit 1; }

    if [ ! -d $DOTFILES/antibody ]; then
        echo "$DOTFILES/antibody does not exist"
        return 1
    fi

    if [ -e "$HOME/.bundles.txt" ]; then
        echo "*** Update antibody ~/.bundles.txt..."
    else
        echo "*** Create antibody ~/.bundles.txt..."
    fi
    antibody bundle < "$DOTFILES/antibody/bundles.txt" > ~/.bundles.txt
    antibody bundle sindresorhus/pure >> ~/.bundles.txt
    antibody bundle < "$DOTFILES/antibody/last_bundles.txt" >> ~/.bundles.txt

}

function setup_zsh {
    command -v zsh 1>/dev/null 2>&1 || { echo "zsh is not installed."; exit 1; }
    local zsh_bin=$(which zsh)
    if [ "$zsh_bin" == "/usr/local/bin/zsh" ]; then
        grep -q $zsh_bin /etc/shells || {
            echo "*** Adding $zsh_bin to /etc/shells..."
            sudo sh -c "echo $zsh_bin >> /etc/shells"
        }
    fi
    if [ "$SHELL" != "$zsh_bin" ]; then
        echo "*** Updating user shell to zsh..."
        chsh -s $zsh_bin
    fi
}

function setup_dotfile {
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

function setup_tmux {
    command -v tmux 1>/dev/null 2>&1 || return 0
    setup_dotfile .tmux.conf
}

# Clone dotfiles
download_dotfiles

# Install requirements
install_homebrew
install_zsh
install_antibody

# Configure zsh
setup_zsh
setup_antibody

# Setup dotfile symlinks
setup_dotfile .aliases
setup_dotfile .zshrc
setup_dotfile .bashrc
setup_dotfile .gitignore_global
setup_dotfile .editorconfig

# Setup tmux config if installed
setup_tmux
