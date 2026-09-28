#!/bin/zsh

if [ ! -e "/opt/homebrew/bin/tailscale" ] && [ -e "/Applications/Tailscale.app" ]; then
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi