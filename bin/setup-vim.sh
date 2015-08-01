#!/usr/bin/env bash

command_exists() {
  command -v "$1" >/dev/null 2>&1 ;
}

# Install latest Vim and MacVim
brew install vim
brew install macvim

# Install vim-plug 
# http://junegunn.kr/2013/09/writing-my-own-vim-plugin-manager/
if [ ! -e "$HOME/.vim/autoload/plug.vim" ]; then
	echo '*** Install vim-plug'
	mkdir -p $HOME/.vim/autoload
	curl -fLo $HOME/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim
fi

[ -d "$HOME/.vim/plugged" ] || { echo '*** Create plugin directory'; mkdir -p $HOME/.vim/plugged; }

# Install YCM
if [ ! -d "$HOME/.vim/plugged/YouCompleteMe" ]; then
	echo '*** Install YCM plugin'
	cd $HOME/.vim/plugged
	git clone git://github.com/Valloric/YouCompleteMe.git
	cd $HOME/.vim/plugged/YouCompleteMe
	git submodule update --init --recursive
fi

if [ -d "$HOME/.vim/plugged/YouCompleteMe" ]; then
	command_exists cmake || { echo '*** Install cmake'; brew install cmake; }
	echo '*** Compile YCM'
	cd $HOME/.vim/plugged/YouCompleteMe
	./install.sh --clang-completer
fi

# BUNDLES=(
# 	"git://github.com/tpope/vim-sensible.git"
# 	"git://github.com/altercation/vim-colors-solarized.git"
# 	"git://github.com/fatih/vim-go.git"
# )

# for url in ${BUNDLES[@]}; do
# 	bundle_name=$(echo $url | sed 's~git://github.com/[a-z]*/\([a-z\-]*\)\.git~\1~')
# 	if [ -d "$HOME/.vim/bundle/$bundle_name" ]; then
# 		echo "*** $bundle_name already installed"
# 	else
# 		echo "*** Installing $bundle_name"
# 		git clone $url $HOME/.vim/bundle/$bundle_name
# 	fi
# done