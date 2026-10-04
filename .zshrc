
# vim :set ts=2 sw=2 sts=2 et :
# ~/.zshrc: executed by zsh(1) for non-login shells.

# path to the local dotfiles repository
if [ -z "${DOTFILES}" ]; then
  if [ -d "${HOME}/.dotfiles" ]; then
    export DOTFILES="${HOME}/.dotfiles"
  fi
fi

# enable colour support
export TERM="xterm-256color"

# enable timestamps in history
export HIST_STAMPS="yyyy-mm-dd"

# we need local ~/.dotfiles directory for this script to work
if [ -z "${DOTFILES}" ]; then
    echo "WARNING: could not find ~/.dotfiles directory" >&2
    return
fi

# set platform name so that we can run scripts based on the OS
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  # shellcheck disable=SC2034
  platform='macos'
  if [[ `uname -m` == 'arm64' ]]; then
    platform_apple_silicon='true'
  fi
fi
unset unamestr

if [ -e "$HOME/.config/sheldon/plugins.toml" ]; then
  export ZSH_PLUGIN_MANAGER="sheldon"
elif [ -e "$HOME/.sheldon/plugins.toml" ]; then
  export ZSH_PLUGIN_MANAGER="sheldon"
fi

###
# Load ZSH configuration
# See https://github.com/caarlos0/dotfiles/blob/master/zsh/zshrc.symlink
###

# all of our zsh files
typeset -U config_files
config_files=($DOTFILES/*/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}; do
  source "$file"
done

if [[ "${ZSH_PLUGIN_MANAGER}" == "sheldon" ]]; then
  eval "$(sheldon source)"
fi

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source "$file"
done

autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit
else
  compinit -C
fi
unset updated_at

autoload -U +X bashcompinit && bashcompinit

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source "$file"
done

unset config_files platform

# shellcheck disable=SC1090
[ -f ~/.localrc ] && . ~/.localrc
