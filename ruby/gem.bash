#!/usr/bin/env bash

# Configure custom RubyGems enviroment only if I don't have rbenv installed.
if [ ! -d "$HOME/.rbenv" ]; then
    export GEM_HOME=$HOME/.gem
    export PATH=$GEM_HOME/bin:$PATH
fi
