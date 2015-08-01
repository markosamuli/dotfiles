# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="sunrise"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew history tmux rvm bundler virtualenv virtualenvwrapper)

# Set '-CC' option for iTerm2 tmux integration
ZSH_TMUX_ITERM2=false

export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv

# brew install python
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
#export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv

export GITCHANGELOG_CONFIG_FILENAME="$HOME/.gitchangelog.rc"

export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# User configuration

# export PATH="$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/local/share/npm/bin:/Users/markosamuli/.rvm/gems/ruby-1.9.3-p429/bin:/Users/markosamuli/.rvm/gems/ruby-1.9.3-p429@global/bin:/Users/markosamuli/.rvm/rubies/ruby-1.9.3-p429/bin:/Users/markosamuli/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

# export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

# The next line updates PATH for the Google Cloud SDK.
source $HOME/google-cloud-sdk/path.zsh.inc

# The next line enables bash completion for gcloud.
source $HOME/google-cloud-sdk/completion.zsh.inc

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export JAVA_7_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home
# export JAVA_8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home
alias java7='export JAVA_HOME=$JAVA_7_HOME;echo JAVA_HOME=$JAVA_7_HOME'
# alias java8='export JAVA_HOME=$JAVA_8_HOME;echo JAVA_HOME=$JAVA_8_HOME'
export JAVA_HOME=$JAVA_7_HOME

# Load local aliases
source $HOME/.aliases

# GitHub API token to avoid Homebrew hitting GitHub API limites
source $HOME/.homebrew

alias subl="sublime"

# RVM
export PATH=$PATH:$HOME/.rvm/bin

# Composer binaries
export PATH=$HOME/.composer/vendor/bin:$PATH

# Gettext tools
export PATH=$PATH:/usr/local/opt/gettext/bin

# Setup path to Go binary and the Go workspace
export GOPATH=$HOME/Projects/golang
export PATH=$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin

docker-ip() {
  boot2docker ip 2> /dev/null
}

# SCM Breeze (https://github.com/ndbroadbent/scm_breeze)
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"
