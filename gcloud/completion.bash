#!/usr/bin/env bash
# vim :set ts=2 sw=2 sts=2 et :

# Cloud SDK bash completion
if [ -n "$CLOUDSDK_ROOT_DIR" ]; then
    # The next line enables bash completion for gcloud.
    source $CLOUDSDK_ROOT_DIR/completion.bash.inc
elif [ -d "/usr/share/google-cloud-sdk" ]; then
    # Google Cloud SDK installed with package manager
    source /usr/share/google-cloud-sdk/completion.bash.inc
fi
