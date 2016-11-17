#!/bin/bash

script=`realpath $0`
dir=`dirname $script`

ln -s ~/.vimrc $dir/vimrc

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle

vim +BundleInstall +qall

cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer --gocode-completer --racer-completer

ln -s ~/.vim/ubuntu-mono-powerline-ttf ~/.local/share/fonts/ubuntu-mono-powerline-ttf

sudo apt-get install silversearcher-ag
