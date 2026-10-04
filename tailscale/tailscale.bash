#!/usr/bin/env bash

if ! type -P tailscale >/dev/null && [ -e "/Applications/Tailscale.app" ]; then
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi
