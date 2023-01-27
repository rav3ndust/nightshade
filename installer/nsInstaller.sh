#!/bin/bash
################################################
# nightshade installer.
#	- by rav3ndust
# installs our "meta-distro" on any Arch-based distribution.
################################################
set -euo pipefail
################################################
# - - - - - Variables - - - - -
################################################
UPDATE="sudo pacman -Sy"
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
ERR_MSG="Sorry, something went wrong."
MKPKG="sudo make install"
PKGS="git xterm arandr nitrogen feh rofi torsocks pamixer opendoas alacritty kitty cmus vim flameshot tmux micro picom mpv pulsemixer gcr webkit2gtk neofetch pavucontrol nnn electrum fish kate gedit zathura nemo sddm chromium amfora firefox qutebrowser tor torbrowser-launcher sxiv scrot slock dmenu conky polkit lxsession networkmanager nm-connection-editor xorg-xkill xorg-xsetroot xscreensaver xautolock xss-lock dunst firejail firetools"
NO_VAL="No valid option selected. Exiting..."
# Script Target locations (located in /usr/bin)
SSC_TARGET="/usr/bin/ssc"
NIGHTSURF_TARGET="/usr/bin/nightsurf"
# Messages. 
ns_Msg="This script is meant to be run on a vanilla Arch installation with GNOME installed. It will install some GNOME extensions, some extra packages, and some GNOME extensions for customization. It will also enable AUR support and install some custom applications." 
STATFILE="larbs.mom"
#####################################################
# - - - - - Functions - - - - -
#####################################################
 _ERR() {
	# this function will run when a problem is detected.
	# will display an error message and exit the script.
	local exitmsg="Now exiting the program. Please review logs."
	echo $ERR_MSG
	sleep 1
	echo $exitmsg
	sleep 1 && exit
}
refresh_repos() {
	echo "Updating repositories..."
	$UPDATE
	echo "Repositories updated."
}
get_Yay() {
	echo "Building yay AUR helper..."
	git clone $YAY_LINK
	cd yay
	makepkg -si || _ERR
	cd $HOME
}
gnome_exts_installation() {
	# We're using a few GNOME extensions. 
	# Only three regularly:
	# - dash-to-dock (for GNOME dock support) 
	# - blur-my-shell (for blurring/transparency effects) 
	# - appindicator - for applet support in GNOME terminal
	local dash2dock="gnome-shell-extension-dash-to-dock" 
	local blurMyShell="gnome-shell-extension-blur-my-shell"
	local appindicator="gnome-shell-extension-appindicator"
	local msg="GNOME extensions installed."
	local msg2="You can customize your extensions in the Extensions app."
	echo "Installing 'Dash to Dock' GNOME extension..." 
	sleep 1
	yay -S $dash2dock || _ERR
	echo "Installing 'Blur My Shell' GNOME extension..." 
	sleep 1
	yay -S $blurMyShell || _ERR
	echo "Installing 'AppIndicator' GNOME extension..."
	sleep 1
	sudo pacman -S $appindicator --noconfirm || _ERR
	sleep 1 && echo "$msg" 
	sleep 1 && echo "$msg2" 
}
desktop_extras() {
	# this function goes in the extras selection area.
	# it will be used for things like:
	# - installing additional desktop environments and window managers
	# - running the gnome_exts_installation func if user desires GNOME extensions
	local opt1="Additional Desktop Environments"
	local opt2="Additional Window Managers"
	local opt3="GNOME Shell Extensions"
	echo "Desktop Extras Selection Options"
	sleep 1
	echo "1 - $opt1 | 2 - $opt2 | 3 - $opt3"
	sleep 1
	echo "Please type your selection: "
	read desktop_selection
	if [[ $desktop_selection == 1 ]]; then
		local gnome="GNOME"
		local kde="KDE"
		local cinnamon="Cinnamon"
		echo "Which of these would you like to install?"
		# TODO add logic to install the above options.
	elif [[ $desktop_selection == 2 ]]; then
		local qtile="Qtile"
		local bspwm="bspwm"
		local openbox="Openbox"
		echo "Which of these would you like to install?"
		# TODO add logic to install the above options.
	elif [[ $desktop_selection == 3 ]]; then
		echo "Installing GNOME Shell extensions..."
		# run the gnome_exts_installation func to install our extensions selection.
		gnome_exts_installation || _ERR
	else
		echo "Exiting the script." && sleep 1
		exit
	fi
}
build_ashWM() {
	echo "Building ashWM..."
	git clone $ASHWM
	cd ashWM
	make || _ERR
	$MKPKG || _ERR
	echo "ashWM built."
	cd $HOME
}
build_ashblocks() {
	echo "Building ashblocks..."
	git clone $ASHBLOCKS
	cd ashblocks
	make || _ERR
	$MKPKG || _ERR
	echo "ashblocks built."
	cd $HOME
}
build_nightsurf() {
	echo "Building Nightsurf browser..."
	git clone $NIGHTSURF
	cd nightsurf
	make || _ERR
	$MKPKG || _ERR
	echo "nightsurf built."
	cd $HOME
}
install_System_Stuff() {
	local pkg_Installation_Err="Package installation failed. Please check logs and try again later."
	# 'st' is the suckless terminal.
	yay -S st || echo $pkg_Installation_Err && sleep 1
	# 'tabbed' is for tabbed browsing sessions in nightsurf
	yay -S tabbed-git || echo $pkg_Installation_Err && sleep 1
	# 'ttf-envy-code-r' is a nice font for us to use.
	yay -S ttf-envy-code-r && fc-cache || echo $pkg_Installation_Err && sleep 1
	# We also want to grab Font Awesome for the images in status bar.
	sudo pacman -S ttf-font-awesome --noconfirm && fc-cache || echo $pkg_Installation_Err && sleep 1
	# We want to include glib for glib.h
	yay -S glib || echo $pkg_Installation_Err && sleep 1
	# install protonvpn-gui for vpn
	yay -S protonvpn-gui || echo $pkg_Installation_Err && sleep 1
}
install_copyStuff() {
	echo "Copying configs and scripts..."
	sleep 1
	echo "Copying Conky.conf..."
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
	# scripts located in two locations:
	#	- $HOME/ashWM/scripts/
	#	- $HOME/ashblocks/
	echo "Making scripts executable..."
	chmod +x $SSC || _ERR
	chmod +x $BATT || _ERR
	chmod +x $NETW || _ERR
	chmod +x $LAUNCH_SSC || _ERR
	chmod +x $NOTIF_HIST || _ERR
	chmod +x $VOL || _ERR
	chmod +x $AUTOSTART || _ERR
	chmod +x $NIGHTSURF_SCRIPT || _ERR
	sudo cp $NIGHTSURF_SCRIPT $NIGHTSURF_TARGET || _ERR
	sudo cp $SSC $SSC_TARGET || _ERR
	echo "Script permissions applied."
}
further_opts() {
	# BROWSER options
	brave="Brave"
	vivaldi="Vivaldi"
	chrome="Google Chrome"
	librewolf="Librewolf"
	ff_dev="Firefox Developer Edition"
	ms_edge="Microsoft Edge"
	# PROGRAMMING options
	code="Code"
	geany="Geany"
	sublime="Sublime Text"
	# GAME options
	s_Tux="SuperTux"
	s_TuxKart="SuperTuxKart"
	xonotic="Xonotic"
	kpati="kPatience"
	mt="Minetest"
	mc="Minecraft"
	# list
	o="1 - Browsers | 2 - Programming Tools | 3 - Games"
	b="1 - $brave | 2 - $vivaldi | 3 - $chrome | 4 - $librewolf | 5 - $ff_dev | 6 - $ms_edge"
	p="1 - $code | 2 - $geany | 3 - $sublime"
	g="1 - $s_Tux | 2 - $xonotic | 3 - $s_TuxKart | 4 - $kpati | 5 - $mt | 6 - $mc"
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
				local package="brave-bin"
				echo "Installing $brave..."
				yay -S $package || _ERR
				echo "$brave installed."
			elif [[ $BROWSER == 2 ]]; then
				local package="vivaldi"
				echo "Installing $vivaldi..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$vivaldi installed."
			elif [[ $BROWSER == 3 ]]; then
				local package="google-chrome"
				echo "Installing $chrome..."
				yay -S $package || _ERR
				echo "$chrome installed."
			elif [[ $BROWSER == 4 ]]; then
				local package="librewolf-bin"
				echo "Installing $librewolf..."
				yay -S $package || _ERR
				echo "$librewolf installed."
			elif [[ $BROWSER == 5 ]]; then
				local package="firefox-developer-edition"
				echo "Installing $ff_dev..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$ff_dev installed."
			elif [[ $BROWSER == 6 ]]; then
				local package="microsoft-edge-stable-bin"
				echo "Installing $ms_edge..."
				yay -S $package || _ERR
				echo "$ms_edge installed."
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
				local package="code"
				echo "Installing $code..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$code installed."
			elif [[ $PRO == 2 ]]; then
				local package="geany"
				echo "Installing $geany..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$geany installed."
			elif [[ $PRO == 3 ]]; then
				local package="sublime-text-4"
				echo "Installing $sublime..."
				yay -S $package || _ERR
				echo "$sublime installed."
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
				local package="supertux"
				echo "Installing $s_Tux..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$s_Tux installed."
			elif [[ $GAME == 2 ]]; then
				local package="xonotic"
				echo "Installing $xonotic..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$xonotic installed."
			elif [[ $GAME == 3 ]]; then
				local package="supertuxkart"
				echo "Installing $s_TuxKart..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$s_TuxKart installed."
			elif [[ $GAME == 4 ]]; then
				local package="kpat"
				echo "Installing $kpati..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$kpati installed."
			elif [[ $GAME == 5 ]]; then
				local package="minetest"
				echo "Installing $mt..."
				sudo pacman -S $package --noconfirm || _ERR
				echo "$mt installed."
			elif [[ $GAME == 6 ]]; then
				local package="minecraft-launcher"
				echo "Installing $mc..."
				yay -S $package || _ERR
				echo "$mc installed."
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
touch $STATFILE
cd
echo "Nightshade Meta-Distribution Installer"
sleep 1
echo "$ns_Msg"
sleep 1
cd $HOME
refresh_repos
echo "Downloading needed packages..."
sudo pacman -S $PKGS --noconfirm
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
