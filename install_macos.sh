#!/bin/bash
echo "Installing basics for MacOS"

echo "Installing homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing git-crypt"
brew install git-crypt

echo "Installing zsh"
brew install zsh
echo "Setting zsh as default shell"
chsh -s "/usr/local/bin/zsh"
echo "Installing OhMyZsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing neovim"
brew install neovim

echo "Installing tmux"
brew install tmux

echo "Installing tmux plugin manager"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "Installing silversearcher"
brew install the_silver_searcher
