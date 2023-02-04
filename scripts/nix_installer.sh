#!/bin/bash
#	- nix package manager installer
# installs the nix package manager, and offers a few core packages to install
set -euo pipefail
############################################
# - - - vars - - - 
############################################
TITLE="nix package manager installer"
VERSION=0.1
ERR="Something went wrong. Please check logs for details."
############################################
error () {
	# error handling
	echo "$ERR"
	sleep 1
	echo "Exiting in 3 seconds.."
	sleep 3 && exit
}
install_nix () {
	# installs the nix package manager
	echo "Installing the Nix package manager."
	sleep 1
	echo "The program will guide you through a series of questions."
	sleep 1
	echo "This will help your Nix installation go just the way you want."
	sleep 1
	sh <(curl -L https://nixos.org/nix/install) --daemon
	sleep 2
	echo "Nix package manager installed."
	sleep 1
}
common_pkg_questionnaire () {	
	# allows the user to install common applications through nix right away if desired
	browsers=("Brave" "Chrome" "Microsoft Edge" "Firefox" "Librewolf" "Tor Browser")
	comms=("Element" "Telegram" "Skype" "Discord" "Hexchat") 
	dev=("VS Code" "Sublime Text" "Gedit" "Sublime Merge")
	sys=("Timeshift" "Alacritty" "Kitty" "Nemo" "Bleachbit")  
	# TODO write the logic for installing each of these options through user choice
}
main () {
	# main function
	# XXX insert logic here
	echo "$TITLE - version $VERSION"
	sleep 1
	install_nix || error
	common_pkg_questionnaire || error
}
############################################
# - - - script entry point - - - 
############################################
main
# TODO 
#	- testing
#	- write logic in a function for updating the installed Nix packages at user command
