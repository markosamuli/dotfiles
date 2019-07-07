#!/bin/zsh

# Check if dist-upgrade is available
if [ -f "/etc/apt/.dist-upgrade" ] ; then
    echo "A distribution upgrade is available."
fi