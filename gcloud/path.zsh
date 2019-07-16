#!/bin/zsh

# Google Cloud SDK
if [ ! -d "/usr/share/google-cloud-sdk" ]; then
  # Load Google Cloud SDK from $HOME/opt, then $HOME and finally /opt
  if [ -d "$HOME/opt/googlecloud-sdk" ]; then
    export CLOUDSDK_ROOT_DIR="$HOME/opt/google-cloud-sdk"
  elif [ -d "$HOME/google-cloud-sdk" ]; then
    export CLOUDSDK_ROOT_DIR="$HOME/google-cloud-sdk"
  elif [ -d "/opt/google-cloud-sdk" ]; then
    export CLOUDSDK_ROOT_DIR="/opt/google-cloud-sdk"
  fi
  if [ -n "$CLOUDSDK_ROOT_DIR" ]; then
    # The next line updates PATH for the Google Cloud SDK.
    source $CLOUDSDK_ROOT_DIR/path.zsh.inc
  fi
fi
