#!/bin/zsh

# Cloud SDK bash completion
if [ -n "$CLOUDSDK_ROOT_DIR" ]; then
  # The next line enables bash completion for gcloud.
  source $CLOUDSDK_ROOT_DIR/completion.zsh.inc
elif [ -d "/usr/share/google-cloud-sdk" ]; then
  source /usr/share/google-cloud-sdk/completion.zsh.inc
fi
