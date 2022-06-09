#!/bin/bash
#
# nightshade installer. 
#	- by rav3ndust
# installs our "meta-distro" on any Arch-based distribution.
#
set -euo pipefail
UPDATE="sudo pacman -Syu" 
DESKTOPFILE="$HOME/nightshade/configs/dwm.desktop"
DESKTOPFILE_2="/usr/share/xsessions/dwm.desktop"
ASHWM="https://github.com/rav3ndust/ashWM"
ASHWM_XSESSION="/usr/share/xsessions/ashWM.desktop"
AUTOSTART="$HOME/ashWM/scripts/autostart.sh"
DWMBLOCKS="https://github.com/rav3ndust/dwmblocks"
YAY_LINK="https://aur.archlinux.org/yay"
NIGHTSURF="https://github.com/rav3ndust/nightsurf"
NIGHTSURF_SCRIPT="$HOME/ashWM/scripts/nightsurf.sh"
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
ERR_MSG="echo 'Sorry, something went wrong. Please check logs.'"
MKPKG="make && sudo make install" 
PKGS="git arandr nitrogen feh rofi pamixer alacritty cmus vim micro picom mpv pulsemixer sl neofetch pavucontrol nnn electrum fish code gedit zathura nemo sddm chromium amfora firefox qutebrowser tor torbrowser-launcher sxiv scrot slock dmenu conky polkit networkmanager nm-connection-editor xorg-xkill xorg-xsetroot xautolock dunst"
refresh_repos() {
	echo "Updating repositories..."
	$UPDATE
	echo "Repositories updated."
}
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
	# 'tabbed' is for tabbed browsing sessions in nightsurf
	yay -S tabbed
	# 'polkit-dumb-agent lets us grant elevated user privs
	yay -S polkit-dumb-agent
	# 'libxft-bgra' fixes a color emoji rendering issue. 
	yay -S libxft-bgra
	# 'ttf-envy-code-r' is a nice font for us to use.
	yay -S ttf-envy-code-r && fc-cache
	# We also want to grab Font Awesome for the images in status bar. 
	sudo pacman -S ttf-font-awesome && fc-cache
}
install_copyStuff() {
	echo "Copying configs and scripts..."
	echo "Copying ssc..."
	sudo cp $HOME/ashWM/scripts/ssc.sh /usr/bin/ssc
	echo "Copied ssc. Copying Conky.conf..."
	sudo mkdir /etc/conky && sudo touch /etc/conky/conky.conf
	sudo cp $CONKYCONF_COPY $CONKYCONF_2
	echo "Conky.conf copied. Copying vimrc..."
	sudo touch $VIMRC_2 && sudo cp $VIMRC_COPY $VIMRC_2
	echo "vimrc copied. Copying dunstrc..."
	sudo mkdir -p $HOME/.config/dunst && sudo mkdir -p $HOME/etc/dunst
	sudo touch $DUNSTRC_2 && sudo touch $DUNSTRC_3
	sudo cp $DUNSTRC_COPY $DUNSTRC_2
	sudo cp $DUNSTRC_COPY $DUNSTRC_3
	echo "dunstrc copied. Copying .desktop files for autostart..."
	sudo touch $DESKTOPFILE_2
	sudo cp $DESKTOPFILE $DESKTOPFILE_2
	echo "Desktop file created. You can now login to ashWM in your login manager."
}
mkexec() {
	# make scripts executable
	echo "Making scripts executable..."
	chmod +x $SSC || $ERR_MSG
	chmod +x $BATT || $ERR_MSG
	chmod +x $NETW || $ERR_MSG
	chmod +x $LAUNCH_SSC || $ERR_MSG
	chmod +x $NOTIF_HIST || $ERR_MSG
	chmod +x $VOL || $ERR_MSG
	chmod +x $AUTOSTART || $ERR_MSG
	chmod +x $NIGHTSURF_SCRIPT || $ERR_MSG
	sudo cp $NIGHTSURF_SCRIPT /usr/bin/nightsurf
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
refresh_repos
echo "Downloading needed packages..."
sudo pacman -S $PKGS
get_Yay
build_ashWM
build_dwmblocks
build_nightsurf
install_System_Stuff
install_copyStuff
mkexec
further_opts
echo "All tasks completed." 
sleep 1
echo "You are now free to log into ashWM through your session manager. Enjoy!"
exit
