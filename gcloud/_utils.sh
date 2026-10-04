#!/usr/bin/env bash

_dotfiles_gke_gcloud_auth_plugin() {
    if command -v gke-gcloud-auth-plugin >/dev/null; then
        export USE_GKE_GCLOUD_AUTH_PLUGIN=True
    fi
}
