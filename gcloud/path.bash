#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Google Cloud SDK
if [ ! -d "/usr/share/google-cloud-sdk" ]; then
    # Load Google Cloud SDK from $HOME/opt, then $HOME and finally /opt
    if [ -d "$HOME/opt/google-cloud-sdk" ]; then
        export CLOUDSDK_ROOT_DIR="$HOME/opt/google-cloud-sdk"
    elif [ -d "$HOME/google-cloud-sdk" ]; then
        export CLOUDSDK_ROOT_DIR="$HOME/google-cloud-sdk"
    elif [ -d "/opt/google-cloud-sdk" ]; then
        export CLOUDSDK_ROOT_DIR="/opt/google-cloud-sdk"
    fi
    if [ -n "$CLOUDSDK_ROOT_DIR" ]; then
        # The next line updates PATH for the Google Cloud SDK.
        source $CLOUDSDK_ROOT_DIR/path.bash.inc
    fi
fi
