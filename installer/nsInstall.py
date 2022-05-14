'''
nightshade Installer
~by rav3ndust (https://rav3ndust.xyz/about.html, https://github.com/rav3ndust)
~MIT License (see LICENSE) 
	- a python installation script for a meta-distro we're calling "nightshade". 
	- it installs a curated list of packages to setup a minimal programming environment.
	- when finished, you will have your choice between a few desktop environments to choose from.
	- we're focusing on minimalism here, so we're making customized forks of window managers including: 
		* dwm (ashWM) 
		* i3 (wiredWM)
		* qtile
		* we might also do a cinnamon spin, to have one 'traditional' DE.
	- (REQ_PKGS):
		* git
		* yay (AUR helper) 
		* arandr (used for GUI display management) 
		* nitrogen (used for managing wallpapers graphically) 
		* feh (for managing wallpapers through the CLI)
		* sddm (simple login manager) 
		* dmenu (simple menu) 
		* conky (system info displayed graphically) 
		* alacritty (gpu-accelerated terminal) 
		* st (simple terminal) 
		* dunst (for handling notifications) 
		* vim, micro (for text editing in the terminal) 
		* code, gedit, leafpad (for editing text graphically) 
		* fish (modern shell) 
		* rofi (launcher) 
		* pulsemixer (volume control in the terminal)
		* pavucontrol (volume control GUI) 
		* dwm, dwmblocks (window manager and system status display) 
		* polkit, polkit-dumb-agent (for handling system privs)
		* nnn (terminal file manager) 
		* nemo (graphical file manager) 
		* cmus (terminal music player) 
		* picom (display compositing)
		* chromium, nightsurf, firefox, qutebrowser (browser collection) 
		* slock (simple display locker) 
		* sxiv (simple image viewer) 
		* scrot (simple screenshot utility) 
		* zathura (PDF and other document viewer) 
		* mpv (videoplayer)
		* tor, torbrowser-launcher 
		* electrum (bitcoin wallet) 
		* some X11 utilities: 
			* xsetroot (xorg-xsetroot) 
			* xkill (xorg-xkill) 
			* xautolock 
		* neofetch, sl (some fun terminal additions) 
		* some net stuff: 
			* networkmanager
			* nm-connection-editor
		* optional additions: 
			* other browsers? (brave, vivaldi, librewolf) 
It is best to run this program on a fresh Arch Linux installation.

Happy hacking!
'''
import os as shell
import subprocess as sp
# vars
ASH_WM = "https://github.com/rav3ndust/ashWM" 
DWMBLOCKS = "https://github.com/rav3ndust/dwmblocks"
SIMPTERM = "https://github.com/rav3ndust/st" 
YAY_LINK = "https://aur.archlinux.org/yay" 
NIGHTSURF = "https://github.com/rav3ndust/nightsurf"
CONKYCONF_COPY = "$HOME/nightshade/configs/conky.conf"
CONKYCONF_2 = "/etc/conky/conky.conf" 
VIMRC_COPY = "$HOME/nightshade/configs/vimrc"
VIMRC_2 = "$HOME/.vimrc"
DUNSTRC_COPY = "$HOME/nightshade/configs/dunstrc"
DUNSTRC_2 = "/etc/dunst/dunstrc"
DUNSTRC_3 = "$HOME/.config/dunst/dunstrc" 
XINITRC_COPY = "$HOME/nightshade/configs/xinitrc"
XINITRC_2 = "/etc/X11/xinit/xinitrc" 
# system call vars
NOTIF_SUCCESS = "notify-send 'Nightshade' 'Software successfully installed.'"
NOTIF_FAIL = "notify-send 'Nightshade' 'Installation failed. Aborting.'"
ERR_MSG = "Something went wrong. Please check logs for errors and try again"
# pkgs from core repo in arr
corePkgs = [
		'git',
		'arandr', 
		'nitrogen', 
		'feh', 
		'rofi', 
		'alacritty', 
		'cmus', 
		'vim', 
		'micro', 
		'picom', 
		'mpv', 
		'pulsemixer', 
		'sl', 
		'neofetch', 
		'pavucontrol',
		'nnn',
		'electrum',
		'fish',
		'code',
		'gedit',
		'zathura',
		'nemo',
		'sddm'
		]
corePkgs_browsers = ['chromium', 'amfora', 'firefox', 'qutebrowser', 'tor', 'torbrowser-launcher']
corePkgs_suckless = ['sxiv', 'scrot', 'dmenu', 'slock']
corePkgs_utils = ['polkit', 'conky', 'networkmanager', 'nm-connection-editor', 'xorg-xkill', 'xorg-xsetroot', 'xautolock']  
# pkgs from AUR in arr
aurPkgs = ['polkit-dumb-agent', '']
# function definitions
def slp():
	# halts the sys 1 sec 
	sleep = "sleep 1"
	shell.system(sleep)
def ERR_EXT:
	# exits the program on error 
	print(ERR_MSG)
	slp()
	exit()
def getYay():
	# downloads, builds, and installs the yay AUR helper
	mkpkg = "cd yay && makepkg -si" 
	print("Downloading and building Yay AUR helper...")
	shell.system(f'git clone {YAY_LINK}')
	shell.system(f'{mkpkg} | {EXT_ERR}')
	print("Yay AUR helper installed.")
	slp()
def makeConfigs():
	# will handle placement of our config files
	allCopied = "All configuration files copied."
	print("Handling various user configuration files...")
	def copyConkyConfig():	# copies conky.conf to /etc/conky/conky.conf
		copying = "Copying conky.conf to /etc/conky/conky.conf..."
		print(copying)
		shell.system(f'sudo cp {CONKYCONF_COPY} {CONKYCONF_2}')
		slp()
		print("conky.conf copied.")
		slp()
	def copyVimrc():	# copies vimrc to ~/.vimrc
		createRC = f'sudo touch {VIMRC_2}' 
		vim = "Copying vimrc to ~/.vimrc..."
		print(vim)
		slp()
		shell.system(createRC)
		shell.system(f'sudo cp {VIMRC_COPY} {VIMRC_2}')
		print("vimrc copied.")
		slp()
	def copyDunstrc():	# copies dunstrc to /etc/dunst/dunstrc and ~/.config/dunst/dunstrc
		dunst = f'Copying dunstrc to {DUNSTRC_2} and {DUNSTRC_3}...'
		print(dunst)
		shell.system(f'sudo cp dunstrc {DUNSTRC_2} {DUNSTRC_3}')
		print("dunstrc copied.")
		slp()
	def copyXinitrc():	# copies to xinitrc to /etc/X11/xinit/xinitrc
		xinitRC = f'Copying xinitrc to {XINITRC_2}.'
		print(xinitRC)
		shell.system(f'sudo cp xinitrc {XINITRC_2}')
		print("xinitrc copied.")
		slp()
	# run the functions for the configs
	copyConkyConfig()
	copyVimrc()
	CopyDunstrc()
	copyXinitrc()
	slp()
	print(allCopied)
	slp()
def buildAshWM():
	# clones, builds, and installs ashWM (dwm fork) 
	mkpkg = "cd ashWM && sudo make install"
	print("Collecting and building ashWM...") 
	shell.system(f'git clone {ASH_WM}')
	shell.system('{mkpkg} | {EXT_ERR}')
	print("ashWM compiled and installed.")
	slp()	
def buildDwmBlocks():
	# clones, builds, and installs our dwmblocks fork
	mkpkg = "cd dwmblocks && sudo make install"
	print("Collecting and building dwmblocks...")
	shell.system(f'git clone {DWMBLOCKS}')
	shell.system(f'{mkpkg} | {ERR_EXT}')
	print("dwmblocks built.")
	slp()
def buildSt():
	# clones, builds, and installs our st fork 
	mkpkg = "cd st && sudo make install" 
	print("Collecting and building st...")
	shell.system(f'git clone {SIMPTERM}')
	shell.system(f'{mkpkg} | {ERR_EXT}')
	print("st built.")
	slp()
def buildNightsurf():
	# clones, builds, and installs our surf fork 
	mkpkg = "cd nightsurf && sudo make install" 
	print("Collecting and building nightsurf...")
	shell.system(f'git clone {NIGHTSURF}')
	shell.system(f'{mkpkg} | {ERR_EXT}')
	print("Nightsurf built.")
	slp()
# program begins here
title = "Nightshade Meta-Distribution Installer" 
print(title)

''' TODO

	- implement functions for: 
		* install different options for window managers or desktop environments(?)
		* make a function for adding additional packages, such as brave or other popular options
	- ensure we have all the needed packages
		* write the logic to install all of the packages
		* build and install packages that need to come from the AUR
		* test the installation script when done for debugging
'''
