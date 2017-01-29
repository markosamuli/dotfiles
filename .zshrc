# shortcut to this dotfiles path is $ZSH
export ZSH="$HOME/.dotfiles"

# your project folder that we can `c [tab]` to
export PROJECTS="$HOME/Projects"

# enable colour support
export TERM="xterm-256color"

# set platform name so that we can run scripts based on the OS
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='macos'
fi

###
# Load ZSH configuration
# See https://github.com/caarlos0/dotfiles/blob/master/zsh/zshrc.symlink
###

# all of our zsh files
typeset -U config_files
config_files=($ZSH/*/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}; do
  source "$file"
done

# load antibody plugins
source ~/.bundles.txt

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

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source "$file"
done

unset config_files updated_at

# use .localrc for SUPER SECRET CRAP that you don't
# want in your public, versioned repo.
# shellcheck disable=SC1090
[ -f ~/.localrc ] && . ~/.localrc

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
elif [[ "$platform" == "linux" ]]; then
  export EDITOR='gvim'
elif [[ "$platform" == "macos" ]]; then
  export EDITOR='mvim'
else
  export EDITOR='vim'
fi

# SSH defaults
export SSH_KEY_PATH="~/.ssh/id_rsa"

# hide the “user@hostname” info when you’re logged in as yourself on your local machine.
export DEFAULT_USER=markosamuli

# We don't want cows when running Ansible
export ANSIBLE_NOCOWS=1

# Custom gitchangelog config
export GITCHANGELOG_CONFIG_FILENAME="$HOME/.gitchangelog.rc"

# Load Google Cloud SDK from $HOME/opt, then /opt
if [ -d "$HOME/opt/google-cloud-sdk" ]; then
  export CLOUDSDK_ROOT_DIR="$HOME/opt/google-cloud-sdk"
elif [ -d "/opt/google-cloud-sdk" ]; then
  export CLOUDSDK_ROOT_DIR="/opt/google-cloud-sdk"
fi

if [ -n "$CLOUDSDK_ROOT_DIR" ]; then
  # The next line updates PATH for the Google Cloud SDK.
  source $CLOUDSDK_ROOT_DIR/path.zsh.inc
  # The next line enables bash completion for gcloud.
  source $CLOUDSDK_ROOT_DIR/completion.zsh.inc
fi

# Load GAE tools to Golang
if [ -d "$HOME/opt/go_appengine" ]; then
  export PATH=$PATH:$HOME/opt/go_appengine
fi

# Local binaries
[ -d "$HOME/bin" ] && export PATH=$HOME/bin:$PATH

# Load local aliases
[ -e "$HOME/.aliases" ] && source $HOME/.aliases

# Homebrew configuration
[ -e "$HOME/.homebrewrc" ] && source $HOME/.homebrewrc

# Composer binaries
[ -d "$HOME/.composer" ] && export PATH=$PATH:$HOME/.composer/vendor/bin

# Set pyenv root
export PYENV_ROOT="$HOME/.pyenv"

# Initialise pyenv and pyenv-virtualenv if installed
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Initialise rbenv if installed
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Load kubectl autocompletion
# source $HOME/Projects/kubernetes/contrib/completions/zsh/kubectl

# Initialise nvm if installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Created by markosamuli.golang Ansible role
export GOPATH=$HOME/Projects/golang
export PATH=$PATH:$GOPATH/bin

# Set paths to Hashicorp tools on Linux
if [[ "$platform" == "linux" ]]; then
  [ -d "/opt/terraform" ] && export PATH=/opt/terraform:$PATH
  [ -d "/opt/packer" ] && export PATH=/opt/packer:$PATH
fi

# Load Google vendor tools and configuration
[ -f ~/.googlerc ] && . ~/.googlerc
