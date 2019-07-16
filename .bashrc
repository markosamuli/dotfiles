# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# shortcut to this dotfiles path is $ZSH
export DOTFILES="$HOME/.dotfiles"

# enable colour support
export TERM="xterm-256color"

# set platform name so that we can run scripts based on the OS
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='macos'
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [[ "$platform" == "linux" ]]; then
  # Add an "alert" alias for long running commands.  Use like so:
  #   sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# all of our bash files
declare -a config_files path_files completion_files
config_files=($DOTFILES/*/*.bash)

# empty the list if we have no matches
if [ "$config_files" = "$DOTFILES/*/*.bash" ]; then
  config_files=()
  path_files=()
  completion_files=()
else
  # path files
  path_files=($DOTFILES/*/path.bash)
  if [ "$path_files" = "$DOTFILES/*/path.bash" ]; then
    path_files=()
  fi
  # remove path_files from config_files
  for file in "${path_files[@]}"; do
    config_files=("${config_files[@]/$file}")
  done
  # completion files
  completion_files=($DOTFILES/*/completion.bash)
  if [ "$completion_files" = "$DOTFILES/*/completion.bash" ]; then
    completion_files=()
  fi
  # remove completion_files from config_files
  for file in "${completion_files[@]}"; do
    config_files=("${config_files[@]/$file}")
  done
  # remove empty items in config_files
  declare -a clean_config_files
  for i in "${!config_files[@]}"; do
    if [ "${config_files[i]}" != "" ]; then
      clean_config_files+=( "${config_files[i]}" )
    fi
  done
  config_files=("${clean_config_files[@]}")
  unset clean_config_files
fi

# load the path files and remove from config_files
for file in "${path_files[@]}"; do
  source "$file"
done

# load everything but the path and completion files
for file in "${config_files[@]}"; do
  source "$file"
done

# load default bash completion on Ubuntu
if [[ "$platform" == "linux" ]]; then
  # enable programmable completion features (you don't need to enable
  # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
  # sources /etc/bash.bashrc).
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
fi

# load every completion after autocomplete loads
for file in "${completion_files[@]}"; do
  source "$file"
done

unset config_files completion_files path_files

# use .localrc for secret
[ -f ~/.localrc ] && . ~/.localrc

# local alias definitions
[ -e ~/.aliases ] && . ~/.aliases

# bash only alias definitions
[ -e ~/.bash_aliases ] && . ~/.bash_aliases
