
#!/usr/bin/env bash

# Initialise Linuxbrew
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
