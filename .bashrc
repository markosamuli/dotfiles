# Local binaries
[ -d "$HOME/bin" ] && export PATH=$HOME/bin:$PATH

# Set pyenv root
export PYENV_ROOT="$HOME/.pyenv"

# Initialise pyenv and pyenv-virtualenv if installed
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Initialise rbenv if installed
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Initialise nvm if installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Created by markosamuli.golang Ansible role
export GOPATH=$HOME/Projects/golang
export PATH=$PATH:$GOPATH/bin