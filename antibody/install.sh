#!/bin/sh

[ -z "$ZSH" ] && { echo "ZSH not defined"; exit 1; }
[ -d "$ZSH/antibody" ] || { echo "$ZSH/antibody does not exist"; exit 1; }

echo "Create/update ~/.bundles.txt..."
antibody bundle < "$ZSH/antibody/bundles.txt" > ~/.bundles.txt
antibody bundle sindresorhus/pure >> ~/.bundles.txt
antibody bundle < "$ZSH/antibody/last_bundles.txt" >> ~/.bundles.txt