#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

configure() {
	echo "Configuring $1..."
	if [[ -d "$HOME/$2" ]]; then
		rm -rf "$HOME/$2"
		ln -sf "$DIR/$2" "$HOME/$2"
	fi
}

confirm() {
	read -p "$1 [Y/n] " -n 1 -r
	echo    # (optional) move to a new line
	[[ $REPLY =~ ^[Yy]?$ ]] # implicitly return condition
}

detect_os() {
	OS="unknown"
	printf "We are running on: "
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		if grep -q "Microsoft" /proc/version; then
			OS="wsl"
	  		echo "WSL"
		else
			OS="linux"
	  		echo "native Linux"
		fi
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		OS="macos"
	        echo "MacOS"
	else
	        echo "unknown"
		echo "please fix me before continuing..."
		exit 1
	fi

	if ! confirm "Is this correct?"; then
		echo "please fix me before continuing..."
		exit 1
	fi

}

if confirm "Do you want to install the tools?"; then
	detect_os
	source "$DIR/install_$OS.sh"
fi

exit 1
configure "neovim" ".config/nvim"
configure "git" ".config/git"
configure "tmux" ".tmux.conf"
configure "zsh" ".zshrc"
configure "oh-my-zsh custom files" ".oh-my-zsh/custom"
