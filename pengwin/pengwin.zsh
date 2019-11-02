#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# Run these only on Pengwin WSL
if [ -d "/usr/local/pengwin-setup.d" ]; then
    UPGRD_CHECK="$(apt-get --just-print upgrade --show-upgraded --assume-no | grep pengwin)"
    if [[ "${UPGRD_CHECK}" == *"pengwin"* ]]; then
        echo "Pengwin core package upgrades found."
        echo "Use 'pengwin-setup' to upgrade them."
    fi
    unset UPGRD_CHECK
fi
