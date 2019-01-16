#!/bin/bash
echo "Installing basics for MacOS"

echo "Installing homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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
