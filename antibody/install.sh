#!/bin/sh

echo "Install/update antibody..."
if which brew >/dev/null 2>&1; then
  brew untap -q getantibody/homebrew-antibody || true
  brew tap -q getantibody/homebrew-antibody
  brew install antibody
else
  curl -sL https://git.io/vwMNi | sh -s
fi

[ -z "$ZSH" ] && { echo "ZSH not defined"; exit 1; }
[ -d "$ZSH/antibody" ] || { echo "$ZSH/antibody does not exist"; exit 1; }

echo "Create/update ~/.bundles.txt..."
antibody bundle < "$ZSH/antibody/bundles.txt" > ~/.bundles.txt
antibody bundle sindresorhus/pure >> ~/.bundles.txt
antibody bundle < "$ZSH/antibody/last_bundles.txt" >> ~/.bundles.txt