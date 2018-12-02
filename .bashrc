# Local binaries
[ -d "$HOME/bin" ] && export PATH=$HOME/bin:$PATH


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Default bash completion on Ubuntu
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

# Golang projects
if [ -d "$HOME/Projects/golang" ]; then
  export GOPATH=$HOME/Projects/golang
  export PATH=$PATH:$GOPATH/bin
fi

# BEGIN ANSIBLE MANAGED BLOCK: pyenv
# Add pyenv into path if installed into default location
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
fi
# Initialise pyenv and pyenv-virtualenv if installed
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi
if command -v pyenv-virtualenv-init 1>/dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi
# END ANSIBLE MANAGED BLOCK: pyenv

# Set paths to Hashicorp tools on Linux
if [[ "$platform" == "linux" ]]; then
  [ -d "/opt/terraform" ] && [ ! -e "/usr/local/bin/terraform" ] && export PATH=/opt/terraform:$PATH
  [ -d "/opt/packer" ] && [ ! -e "/usr/local/bin/packer" ] && export PATH=/opt/packer:$PATH
fi

# Initialise rbenv if installed
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Initialise nvm if installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
