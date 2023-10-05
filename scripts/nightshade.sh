#!/usr/bin/env bash
# "nightshade.sh"
set -euo pipefail
# Nightshade Environment (Auto-Installation Script)
#   - by rav3ndust (https://rav3ndust.xyz)
# Installs the Nightshade environment.
# Custom window manager, desktop environments, games, applications, and more.
# Handles necessary configurations of files as well.
# Assumes a Debian/Ubuntu operating environment.
#############################################################################
TITLE="Nightshade Auto-Installation Script"; VERSION=0.1
# application vars
core_pkgs=("git" "vim" "gpa" "obs-studio" "filezilla" "fish" "cmus" "htop" "gnome-weather" "gnome-todo" "mpv" "neofetch" "chromium" "firefox" "torbrowser-launcher" "rhythmbox" "telegram-desktop" "cowsay" "wireshark" "ufw" "gufw" "virtualbox-qt" "sublime-text" "sublime-merge" "thunderbird") # TODO: Add other packages to core_pkgs? 
# .deb games, Steam
games=("steam" "assaultcube" "openarena" "aisleriot" "gweled" "supertuxkart" "supertux2")
# flatpak applications
flatseal="com.github.tchx84.Flatseal"               # Flatseal (flatpak permissions manager)
blackbox="com.raggesilver.BlackBox"                 # Blackbox (GTK4 Terminal) 
electrum="org.electrum.electrum"                    # Electrum Bitcoin Wallet
feather="org.featherwallet.Feather"                 # Feather Monero Wallet
mullvad_browser="net.mullvad.MullvadBrowser"        # Mullvad Browser
skype="com.skype.Client"                            # Skype
nicotine="org.nicotine_plus.Nicotine"               # Nicotine+, Soulseek client
pulsar="dev.pulsar_edit.Pulsar"                     # Pulsar text editor
minetest="net.minetest.Minetest"                    # Minetest
retroarch="org.libretro.RetroArch"                  # RetroArch
taisei="org.taisei_project.Taisei"                  # Taisei
xonotic="org.xonotic.Xonotic"                       # Xonotic
sc_pinball="com.github.k4zmu2a.spacecadetpinball"   # Space Cadet Pinball
#############################################################################
# functions
#############################################################################
error_handler () {
  # simple error handling
  local err1="Sorry - something went wrong."
  local err2="Please check logs and try again."
  echo "$err1" && sleep 1
  echo "$err2" && sleep 1
  echo "Exiting script in 3 seconds..."
  sleep 3 && exit
}
install_additional_packages () {
  # installs additional .deb packages.
  # Currently, these are Brave Browser and Element Desktop.
  local additional_pkgs=("brave-browser" "element-desktop")
  # TODO fill in the logic (packaging from brave.com and element.io)
  sudo apt update && sudo apt install $additional_pkgs -y
}
install_flatpaks () {
  # installs the flatpak applications
  echo "Installing Flatpak applications..." && sleep 1
  # TODO build out the logic
}
install_wired () {
  # installs wiredWM, our heavily customised i3wm
  local repo="https://github.com/rav3ndust/wiredWM"
  local wired_script="$HOME/.dev/wiredWM/scripts-config/install.sh"
  echo "Installing and configuring wiredWM..." && sleep 1
  cd $HOME && mkdir .dev && cd .dev
  git clone $repo && cd wiredWM
  bash $wired_script
}
main () {
  # main function
  echo "$TITLE - version $VERSION" && sleep 2
  echo "Installing core packages..." && sleep 1
  sudo apt update && sudo apt install $core_pkgs -y
}
#############################################################################
# script entry point
#############################################################################
main
