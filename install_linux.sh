#!/bin/bash

echo "Installing basics for Linux"

echo "Installing git-crypt"
apt install git-crypt

echo "Installing zsh"
apt install zsh
echo "Setting zsh as default shell"
chsh -s "/usr/local/bin/zsh"
echo "Installing OhMyZsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing neovim"
apt install neovim

echo "Installing tmux"
apt install tmux

echo "Installing silversearcher"
apt install silversearcher-ag
