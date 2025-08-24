#!/bin/bash

sudo apt-get -y install silversearcher-ag python3-dev golang fonts-firacode fzf python3-clang

script=`realpath $0`
dir=`dirname $script`

ln -s ~/.vimrc $dir/vimrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle

vim +BundleInstall +qall

cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer --gocode-completer --racer-completer

