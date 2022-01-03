#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

DOTFILES_REPO=https://github.com/markosamuli/dotfiles.git
DOTFILES=$HOME/.dotfiles

GITHUB_RAW=https://raw.githubusercontent.com
HOMEBREW_INSTALL=${GITHUB_RAW}/Homebrew/install/master/install

error() {
    echo "$@" 1>&2
}

configure_install() {
    if [ -n "${PS1}" ]; then
        INTERACTIVE=true
    elif tty -s; then
        INTERACTIVE=true
    fi
    if [ -z "${ZSH_PLUGIN_MANAGER}" ]; then
        if command -v sheldon 1>/dev/null 2>&1; then
            ZSH_PLUGIN_MANAGER="sheldon"
        elif command -v antibody 1>/dev/null 2>&1; then
            ZSH_PLUGIN_MANAGER="antibody"
        else
            ZSH_PLUGIN_MANAGER="sheldon"
        fi
    fi
    if [ -z "${INTERACTIVE}" ]; then
        INSTALL_HOMEBREW=${INSTALL_HOMEBREW:-true}
        INSTALL_ZSH=${INSTALL_ZSH:-true}
        INSTALL_SHELDON=${INSTALL_SHELDON:-true}
        INSTALL_ANTIBODY=${INSTALL_ANTIBODY:-true}
        UPGRADE_ANTIBODY=${UPGRADE_ANTIBODY:-true}
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

# Get latest antibody version from GitHub
latest_antibody_version() {
    local latest_release=""
    local errmsg="[antibody] ERROR: Couldn't get latest antibody release version."
    latest_release=$(get_latest_release getantibody/antibody)
    [ -z "${latest_release}" ] && {
        error "${errmsg}"
        return 1
    }
    echo "${latest_release/v/}"
}

# Get installed antibody version
installed_antibody_version() {
    local version=""
    command -v antibody 1>/dev/null 2>&1 || return 1
    version=$(antibody -v 2>&1 | grep 'antibody version' | awk '{ print $3 }')
    echo "${version/v/}"
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

init_submodules() {
    git -C "${DOTFILES}" submodule init
    git -C "${DOTFILES}" submodule update
}

install_sheldon() {

    if [[ "${ZSH_PLUGIN_MANAGER}" != "sheldon" ]]; then
        echo "[sheldon] Skipping setup as sheldon is not set as the active plugin manager."
        return 0
    fi

    command -v sheldon 1>/dev/null 2>&1 && return 0

    echo "[sheldon] sheldon is not installed"
    if [ -z "${INSTALL_SHELDON}" ]; then
        read -r -p "Do you want to install it now? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                echo "[sheldon] Skipping sheldon setup."
                return 0
                ;;
        esac
    elif [ "${INSTALL_SHELDON}" != "true" ]; then
        echo "[sheldon] Skipping sheldon setup."
        return 0
    fi

    if [ "$(uname -s)" == "Darwin" ]; then
        install_sheldon_with_homebrew
    else
        echo '[sheldon] Install not supported.'
        return 1
    fi
}

install_sheldon_with_homebrew() {
    echo "[sheldon] Installing sheldon with Homebrew..."
    brew install sheldon
}

install_antibody_with_homebrew() {
    echo "[antibody] Installing antibody with Homebrew..."
    brew install getantibody/tap/antibody
}

install_antibody_with_installer() {
    echo "[antibody] Installing antibody with the installer..."
    command -v curl 1>/dev/null 2>&1 || {
        error "[antibody] FAILED: cURL is not installed"
        exit 1
    }
    curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
}

install_antibody() {

    [[ "${ZSH_PLUGIN_MANAGER}" != "antibody" ]] && return 1

    if [[ $(uname -s) == 'Darwin' ]] && [[ $(uname -m) == 'arm64' ]]; then
        echo "[antibody] WARNING: Skipping antibody setup on Apple Silicon."
        return 1
    fi

    command -v antibody 1>/dev/null 2>&1 && return 0

    echo "[antibody] antibody is not installed"
    if [ -z "${INSTALL_ANTIBODY}" ]; then
        read -r -p "Do you want to install it now? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                echo "[antibody] Skipping antibody setup."
                return 0
                ;;
        esac
    elif [ "${INSTALL_ANTIBODY}" != "true" ]; then
        echo "[antibody] Skipping antibody setup."
        return 0
    fi

    if [ "$(uname -s)" == "Darwin" ]; then
        install_antibody_with_homebrew
    else
        install_antibody_with_installer
    fi
}

upgrade_antibody_with_homebrew() {
    echo "[antibody] Upgrading antibody with Homebrew..."
    brew upgrade getantibody/tap/antibody
}

update_antibody() {

    if [[ $(uname -s) == 'Darwin' ]] && [[ $(uname -m) == 'arm64' ]]; then
        echo "[antibody] WARNING: Skipping antibody setup on Apple Silicon."
        return 1
    fi

    local latest_version
    latest_version=$(latest_antibody_version)
    installed_version=$(installed_antibody_version)
    if [ "${latest_version}" == "${installed_version}" ]; then
        return 0
    fi

    echo "[antibody] Latest antibody version: ${latest_version}"
    echo "[antibody] Installed antibody version: ${installed_version}"
    if [ -z "${UPGRADE_ANTIBODY}" ]; then
        read -r -p "Do you want to upgrade? [y/N] " response

        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                echo "[antibody] Skipping antibody upgrade."
                return 0
                ;;
        esac
    elif [ "${UPGRADE_ANTIBODY}" != "true" ]; then
        echo "[antibody] Skipping antibody upgrade."
        return 0
    fi

    if [ "$(uname -s)" == "Darwin" ]; then
        upgrade_antibody_with_homebrew
    else
        install_antibody_with_installer
    fi
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

    echo "[zsh] zsh is not installed from Homebrew"
    if [ -z "${INSTALL_ZSH}" ]; then
        read -r -p "Do you want to install it now? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                echo "[zsh] skipping zsh setup"
                return 0
                ;;
        esac
    elif [ "${INSTALL_ZSH}" != "true" ]; then
        echo "[zsh] skipping zsh setup"
        return 0
    fi

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

    echo "[zsh] zsh is not installed"
    if [ -z "${INSTALL_ZSH}" ]; then
        read -r -p "Do you want to install it now? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                echo "[zsh] Skipping zsh setup."
                return 0
                ;;
        esac
    elif [ "${INSTALL_ZSH}" != "true" ]; then
        echo "[zsh] skipping zsh setup"
        return 0
    fi

    echo "[zsh] Installing zsh..."
    sudo apt-get install -y zsh
}

# Install Homebrew on macOS
install_homebrew() {

    if [ "$(uname -s)" != "Darwin" ]; then
        return 0
    fi

    command -v brew 1>/dev/null 2>&1 && return 0

    echo "[homebrew] Homebrew not installed"
    if [ -z "${INSTALL_HOMEBREW}" ]; then
        read -r -p "Do you want to install it now? [y/N] " response
        case "$response" in
            [yY][eE][sS] | [yY]) ;;
            *)
                echo "[homebrew] Skipping Homebrew setup."
                return 0
                ;;
        esac
    elif [ "${INSTALL_HOMEBREW}" != "true" ]; then
        echo "[homebrew] Skipping Homebrew setup."
        return 0
    fi

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

    if [[ $(uname -s) == 'Darwin' ]] && [[ $(uname -m) == 'arm64' ]]; then
        echo "[antibody] WARNING: Skipping antibody setup on Apple Silicon."
        return 1
    fi

    command -v antibody 1>/dev/null 2>&1 || {
        error "[antibody] FAILED: antibody is not installed"
        exit 1
    }

    if [ ! -d "${DOTFILES}/antibody" ]; then
        error "[antibody] FAILED: $DOTFILES/antibody does not exist"
        return 1
    fi

    if [ -e "${HOME}/.bundles.txt" ]; then
        echo "[antibody] Updating ~/.bundles.txt..."
    else
        echo "[antibody] Creating ~/.bundles.txt..."
    fi
    antibody bundle <"${DOTFILES}/antibody/bundles.txt" >~/.bundles.txt
    antibody bundle sindresorhus/pure >>~/.bundles.txt
    antibody bundle <"${DOTFILES}/antibody/last_bundles.txt" >>~/.bundles.txt
}

setup_sheldon() {

    command -v sheldon 1>/dev/null 2>&1 || {
        error "[sheldon] FAILED: sheldon is not installed"
        exit 1
    }

    if [ ! -e "${HOME}/.sheldon/plugins.toml" ]; then
        echo "[sheldon] Creating ~/.sheldon/plugins.toml symlink"
        mkdir -p "${HOME}/.sheldon"
        setup_dotfile ".sheldon/plugins.toml"
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
        "${DOTFILES}"
        ~/.cache/antibody
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
        .bashrc
        .gitignore_global
        .editorconfig
        .markdownlintrc
    )
    for file in "${dotfile_symlinks[@]}"; do
        backup_dotfile "${file}"
        setup_dotfile "${file}"
    done
}

# Setup symlink to Hammerspoon configuration if installed
setup_hammerspoon() {
    local hammerspoon_dir="${HOME}/.hammerspoon"
    if [ "$(uname -s)" != "Darwin" ]; then
        return 0
    fi
    if [ ! -e "/Applications/Hammerspoon.app" ]; then
        return 0
    fi
    echo "[hammerspoon] Hammerspoon installed, adding configuration..."
    if [ ! -d "${hammerspoon_dir}" ]; then
        mkdir -p "${hammerspoon_dir}" || {
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

    local gitconfig_diff_tool
    gitconfig_diff_tool=$(git config --global --get diff.tool)
    if [ -z "${gitconfig_diff_tool}" ]; then
        echo "[git] Default diff.tool is not configured."
        setup_default_git_diff_tool "${difftools[@]}"
    fi

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

    local gitconfig_merge_tool
    gitconfig_merge_tool=$(git config --global --get merge.tool)
    if [ -z "${gitconfig_merge_tool}" ]; then
        echo "[git] Default merge.tool not configured."
        setup_default_git_merge_tool "${mergetools[@]}"
    fi

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
    man_files=(
        z/z.1
    )
    local update_mandb=0
    local filename
    local man_file
    for file in "${man_files[@]}"; do
        filename=$(basename "${file}")
        man_file="${man_dir}/${filename}"
        if [[ ! -f "${man_file}" ]]; then
            echo "[man] install ${man_file}"
            sudo cp "${DOTFILES}/${file}" "${man_file}" || {
                error "[man] FAILED: couldn't create file ${man_file}"
                exit 1
            }
            sudo chmod 644 "${man_file}"
            update_mandb=1
        fi
    done
    if [[ "${update_mandb}" == "1" ]]; then
        if command -v mandb >/dev/null; then
            echo "[man] update mandb"
            sudo mandb -q
        fi
    fi
}

install_requirements() {
    install_homebrew
    install_zsh
    if [[ "$ZSH_PLUGIN_MANAGER" == "sheldon" ]]; then
        install_sheldon
    elif [[ "$ZSH_PLUGIN_MANAGER" == "antibody" ]]; then
        install_antibody
        update_antibody
    fi
    install_vim
    install_man_pages
}

configure_zsh() {
    setup_zsh
    if [[ "$ZSH_PLUGIN_MANAGER" == "sheldon" ]]; then
        setup_sheldon
    elif [[ "$ZSH_PLUGIN_MANAGER" == "antibody" ]]; then
        setup_antibody
    fi
}

# Configure install script
configure_install

# Clone dotfiles
download_dotfiles

# Initialise Git submodules
init_submodules

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

# Setup Hammerspoon configuration
setup_hammerspoon

# Setup Git to include .gitconfig from .dotfiles
setup_gitconfig
setup_git_editor
setup_git_difftool
setup_git_mergetool

# Fix permissions
fix_permissions

# Check if interactive install is required
require_interactive_install
