#!/bin/bash
#############################
# nightshade installer.
#	- by rav3ndust
# installs our "meta-distro" on any Arch-based distribution.
#############################
set -euo pipefail
UPDATE="sudo pacman -Syu"
DESKTOPFILE="$HOME/nightshade/configs/dwm.desktop"
DESKTOPFILE_2="/usr/share/xsessions/dwm.desktop"
ASHWM="https://github.com/rav3ndust/ashWM"
ASHWM_XSESSION="/usr/share/xsessions/ashWM.desktop"
AUTOSTART="$HOME/ashWM/scripts/autostart.sh"
ASHBLOCKS="https://github.com/rav3ndust/ashblocks"
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
BATT="$HOME/ashblocks/battery.sh"
NETW="$HOME/ashblocks/internet.sh"
LAUNCH_SSC="$HOME/ashblocks/launchssc.sh"
NOTIF_HIST="$HOME/ashblocks/notif-history.sh"
VOL="$HOME/ashblocks/volume.sh"
# system stuff
ERR_MSG="echo 'Sorry, something went wrong. Please check logs.'"
MKPKG="sudo make install"
PKGS="git arandr nitrogen feh rofi torsocks pamixer opendoas alacritty kitty cmus vim flameshot tmux micro picom mpv pulsemixer gcr webkit2gtk neofetch pavucontrol nnn electrum fish kate gedit zathura nemo sddm chromium amfora firefox qutebrowser tor torbrowser-launcher sxiv scrot slock dmenu conky polkit lxsession networkmanager nm-connection-editor xorg-xkill xorg-xsetroot xscreensaver xautolock dunst"
NO_VAL="No valid option selected. Exiting..."
# functions
function refresh_repos() {
	echo "Updating repositories..."
	$UPDATE
	echo "Repositories updated."
}
function get_Yay() {
	echo "Building yay AUR helper..."
	git clone $YAY_LINK
	cd yay
	makepkg -si || $ERR_MSG
	cd $HOME
}
function build_ashWM() {
	echo "Building ashWM..."
	git clone $ASHWM
	cd ashWM
	make || $ERR_MSG
	$MKPKG || $ERR_MSG
	echo "ashWM built."
	cd $HOME
}
function build_ashblocks() {
	echo "Building ashblocks..."
	git clone $ASHBLOCKS
	cd ashblocks
	make || $ERR_MSG
	$MKPKG || $ERR_MSG
	echo "ashblocks built."
	cd $HOME
}
function build_nightsurf() {
	echo "Building nightsurf browser..."
	git clone $NIGHTSURF
	cd nightsurf
	make || $ERR_MSG
	$MKPKG || $ERR_MSG
	echo "nightsurf built."
	cd $HOME
}
function install_System_Stuff() {
	# 'st' is the suckless terminal.
	yay -S st
	# 'tabbed' is for tabbed browsing sessions in nightsurf
	yay -S tabbed-git
	# 'ttf-envy-code-r' is a nice font for us to use.
	yay -S ttf-envy-code-r && fc-cache
	# We also want to grab Font Awesome for the images in status bar.
	sudo pacman -S ttf-font-awesome --noconfirm && fc-cache
	# We want to include glib for glib.h
	yay -S glib
	# install protonvpn-gui for vpn
	yay -S protonvpn-gui
}
function install_copyStuff() {
	echo "Copying configs and scripts..."
	echo "Copying ssc..."
	#sudo cp $HOME/ashWM/scripts/ssc.sh /usr/bin/ssc
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
function mkexec() {
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
	sudo cp $SSC /usr/bin/ssc
	echo "Script permissions applied."
}
function further_opts() {
	o="1 - Browsers | 2 - Programming Tools | 3 - Games"
	b="1 - Brave | 2 - Vivaldi | 3 - Chrome | 4 - Librewolf | 5 - Firefox Developer Edition"
	p="1 - code | 2 - geany"
	g="1 - SuperTux | 2 - Xonotic | 3 - SuperTuxKart | 4 - kPatience | 5 - Minetest"
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
				sudo pacman -S vivaldi --noconfirm || $ERR_MSG
				echo "Vivaldi installed."
			elif [[ $BROWSER == 3 ]]; then
				echo "Installing Chrome..."
				yay -S google-chrome || $ERR_MSG
				echo "Chrome installed."
			elif [[ $BROWSER == 4 ]]; then
				echo "Installing Librewolf..."
				yay -S librewolf-bin || $ERR_MSG
				echo "Librewolf installed."
			elif [[ $BROWSER == 5 ]]; then
				echo "Installing Firefox Developer Edition..."
				sudo pacman -S firefox-developer-edition --noconfirm || $ERR_MSG
				echo "Firefox Developer Edition installed."
			else
				echo $NO_VAL
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
				echo "Installing Code..."
				sudo pacman -S code --noconfirm || $ERR_MSG
				echo "Code installed."
			elif [[ $PRO == 2 ]]; then
				echo "Installing Geany..."
				sudo pacman -S geany --noconfirm || $ERR_MSG
				echo "Geany installed."
			else
				echo $NO_VAL
				exit
			fi
		elif [[ $CATEGORY == 3 ]]; then
			# list the game options
			echo "GAMES OPTIONS: "
			echo $g
			sleep 1
			echo "Your selection here: "
			read GAME
			if [[ $GAME == 1 ]]; then
				echo "Installing SuperTux..."
				sudo pacman -S supertux --noconfirm || $ERR_MSG
				echo "SuperTux installed."
			elif [[ $GAME == 2 ]]; then
				echo "Installing Xonotic..."
				sudo pacman -S xonotic --noconfirm || $ERR_MSG
				echo "Xonotic installed."
			elif [[ $GAME == 3 ]]; then
				echo "Installing SuperTuxKart..."
				sudo pacman -S supertuxkart --noconfirm || $ERR_MSG
				echo "SuperTuxKart installed."
			elif [[ $GAME == 4 ]]; then
				echo "Installing kPatience..."
				sudo pacman -S kpat --noconfirm || $ERR_MSG
				echo "kPatience installed."
			elif [[ $GAME == 5 ]]; then
				echo "Installing Minetest..."
				sudo pacman -S minetest --noconfirm || $ERR_MSG
				echo "Installed Minetest."
			else
				echo $NO_VAL
				exit
			fi
		else
			echo $NO_VAL
			exit
		fi
	elif [[ $SFTWARE == 2 ]]; then
		echo "Excellent!" && sleep 1
		echo "Your installation is now finished."
		sleep 1
		echo "Script exiting."
		exit
	else
		echo $NO_VAL
		exit
	fi
}
# script runs here
echo "Nightshade Meta-Distribution Installer"
cd $HOME
#refresh_repos
echo "Downloading needed packages..."
sudo pacman -S $PKGS
get_Yay
build_ashWM
build_ashblocks
build_nightsurf
install_System_Stuff
install_copyStuff
mkexec
further_opts
echo "All tasks completed."
sleep 1
echo "You are now free to log into ashWM through your session manager. Enjoy!"
exit
# NOTE: any other packages we want to remove/add?
