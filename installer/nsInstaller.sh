#!/bin/bash
#
# nightshade installer. 
#	- by rav3ndust
# installs our "meta-distro" on any Arch-based distribution.
#
set -euo pipefail
ASHWM="https://github.com/rav3ndust/ashWM"
ASHWM_XSESSION="/usr/share/xsessions/ashWM.desktop"
AUTOSTART="$HOME/ashWM/scripts/autostart.sh"
DWMBLOCKS="https://github.com/rav3ndust/dwmblocks"
YAY_LINK="https://aur.archlinux.org/yay"
NIGHTSURF="https://github.com/rav3ndust/nightsurf"
CONKYCONF_COPY="$HOME/nightshade/configs/conky.conf"
CONKYCONF_2="/etc/conky/conky.conf"
VIMRC_COPY="$HOME/nightshade/configs/vimrc"
VIMRC_2="$HOME/.vimrc"
DUNSTRC_COPY="$HOME/nightshade/configs/dunstrc"
DUNSTRC_2="$HOME/.config/dunst/dunstrc"
DUNSTRC_3="/etc/dunst/dunstrc"
# script locations
SSC="$HOME/ashWM/scripts/ssc.sh"
BATT="$HOME/dwmblocks/battery.sh"
NETW="$HOME/dwmblocks/internet.sh"
LAUNCH_SSC="$HOME/dwmblocks/launchssc.sh"
NOTIF_HIST="$HOME/dwmblocks/notif-history.sh"
VOL="$HOME/dwmblocks/volume.sh"
# system stuff
ERR_MSG="Sorry, something went wrong. Please check logs."
MKPKG=$(make && sudo make install) 
PKGS="git arandr nitrogen feh rofi alacritty cmus vim micro picom mpv pulsemixer sl neofetch pavucontrol nnn electrum fish code gedit zathura nemo sddm chromium amfora firefox qutebrowser tor torbrowser-launcher sxiv scrot slock dmenu conky polkit networkmanager nm-connection-editor xorg-xkill xorg-xsetroot xautolock dunst"
# functions
get_Yay() {
	echo "Building yay AUR helper..."
	git clone $YAY_LINK
	cd yay
	makepkg -si || $ERR_MSG
	cd $HOME
}
build_ashWM() {
	echo "Building ashWM..."
	git clone $ASHWM
	cd ashWM
	$MKPKG || $ERR_MSG
	echo "ashWM built."
	cd $HOME
}
build_dwmblocks() {
	echo "Building dwmblocks..."
	git clone $DWMBLOCKS
	cd dwmblocks
	$MKPKG || $ERR_MSG
	echo "dwmblocks built."
	cd $HOME
}
build_nightsurf() {
	echo "Building nightsurf browser..."
	git clone $NIGHTSURF
	cd nightsurf
	$MKPKG || $ERR_MSG
	echo "nightsurf built."
	cd $HOME
}
install_System_Stuff() {
	# 'escrotum' is the base of our screenshot tool, ssc.
	yay -S escrotum
	# 'st' is the suckless terminal.
	yay -S st
	# 'polkit-dumb-agent lets us grant elevated user privs
	yay -S polkit-dumb-agent
}

install_copyStuff() {
	sudo cp $HOME/ashWM/scripts/ssc.sh /usr/bin/ssc
	sudo cp $CONKYCONF_COPY $CONKYCONF_2
	sudo touch $VIMRC_2 && sudo cp $VIMRC_COPY $VIMRC_2
	sudo 
}
mkexec() {
	# make scripts executable.
	echo "Making scripts executable..."
	chmod +x $SSC || $ERR_MSG
	chmod +x $BATT || $ERR_MSG
	chmod +x $NETW || $ERR_MSG
	chmod +x $LAUNCH_SSC || $ERR_MSG
	chmod +x $NOTIF_HIST || $ERR_MSG
	chmod +x $VOL || $ERR_MSG
	chmod +x $AUTOSTART || $ERR_MSG
	echo "Script permissions applied."
}
further_opts() {
	o="1 - Browsers | 2 - Programming Tools"
	b="1 - Brave | 2 - Vivaldi | 3 - Chrome | 4 - Librewolf"
	p="1 - kate | 2 - geany"
	echo "Would you like to install other software?"
	echo "Type '1' for YES or '2' for NO."
	read SFTWARE
	if [[ $SFTWARE == 1 ]]; then
		echo "What software category would you like?"
		echo "Please select your option by entering the number corresponding to its entry in the menu."
		sleep 1 
		echo $o
		sleep 1
		echo "Type your choice: "
		read CATEGORY
		if [[ $CATEGORY == 1 ]]; then
			# list the browser options
			echo "BROWSER OPTIONS:"
			echo $b
			sleep 1
			echo "Your selection here: "
			read BROWSER
			if [[ $BROWSER == 1 ]]; then
				echo "Installing Brave..."
				yay -S brave-bin || $ERR_MSG
				echo "Brave installed."
			elif [[ $BROWSER == 2 ]]; then
				echo "Installing Vivaldi..."
				sudo pacman -S vivaldi-stable || $ERR_MSG
				echo "Vivaldi installed."
			elif [[ $BROWSER == 3 ]]; then
				echo "Installing Chrome..."
				yay -S google-chrome-stable || $ERR_MSG
				echo "Chrome installed."
			elif [[ $BROWSER == 4 ]]; then
				echo "Installing Librewolf..."
				yay -S librewolf || $ERR_MSG
				echo "Librewolf installed."
			else
				echo "No valid option selected. Exiting."
				exit
			fi
		elif [[ $CATEGORY == 2 ]]; then
			# list the dev tool options
			echo "PROGRAMMING TOOLS OPTIONS: "
			echo $p
			sleep 1
			echo "Your selection here: "
			read PRO
			if [[ $PRO == 1 ]]; then
				echo "Installing Kate..."
				sudo pacman -S kate || $ERR_MSG
				echo "Kate installed."
			elif [[ $PRO == 2 ]]; then
				echo "Installing Geany..."
				sudo pacman -S geany || $ERR_MSG
				echo "Geany installed."
			else
				echo "No valid option selected. Exiting."
				exit
			fi
		else
			echo "No valid option selected."
			exit
		fi
	elif [[ $SFTWARE == 2 ]]; then
		echo "Excellent!" && sleep 1
		echo "Your installation is now finished."
		sleep 1
		echo "Script exiting."
		exit
	else 
		echo "No valid option selected. Exiting."
		exit
	fi


}
# script runs here
echo "Nightshade Meta-Distribution Installer"
cd $HOME
sudo pacman -S git
#TODO
# Finish the copyStuff() function - make sure all configs are where they belong.
# Make sure we have all the packages we need in the installer.
# Finish the logic for anymore functions we need.
# Finish writing the script itself.
#
