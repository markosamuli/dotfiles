#!/bin/sh

[ -z "$DOTFILES" ] && { echo "DOTFILES not defined"; exit 1; }
[ -d "$DOTFILES/antibody" ] || { echo "$DOTFILES/antibody does not exist"; exit 1; }

command -v antibody 1>/dev/null 2>&1 || { echo "antibody is not installed"; exit 1; }

echo "Create/update ~/.bundles.txt..."
antibody bundle < "$DOTFILES/antibody/bundles.txt" > ~/.bundles.txt
antibody bundle sindresorhus/pure >> ~/.bundles.txt
antibody bundle < "$DOTFILES/antibody/last_bundles.txt" >> ~/.bundles.txt
