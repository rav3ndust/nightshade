# nightshade
Auto-Installation scripts for my Arch "meta-distribution"

Best installed on a vanilla Arch system post-installation: 

### Quick Steps

Here's a quick rundown of how to quickly get **ashWM** ([my dwm fork](https://github.com/rav3ndust/ashWM)) and a collection of curated and customized software, along with some of my other original scripts and programs that come together to make a minimal, cohesive, and suckless system.

1. Have an instance of Arch Linux (preferably, or a system based on Arch, but officially unsupported)
2. Ensure you have **git** and **python** installed: `sudo pacman -S git python`
3. Clone this repository: `git clone https://github.com/rav3ndust/nightshade`
4. Switch to your new *nightshade* directory: `cd nightshade` 
5. Make the installation script executable: `chmod +x nsInstaller.sh`
6. Run the installer: `./nsInstaller.sh` 

When finished, you can reboot your machine, and you will be presented with an SDDM session where you can login. 


###### *Note that we are also working on finishing up a Python installer - this will be updated in the repo when it is finished.* 
**More documentation to come!**

## Credits

This small little "meta-distro" stands on top of the shoulders of giants and a swath of great software: 

### [Arch Linux](https://archlinux.org)

> The distro we all know and love.

### [Suckless](https://suckless.org)

> Community who appreciates and develops minimalist and open software.
>> We also incorporate dmenu, scrot, sxiv, and more of my own forks of suckless software. 

### [Luke Smith](https://github.com/LukeSmithxyz)

> ashWM is a fork of Luke's build of dwm with my own scripts, keybinds, and aesthetics on top.

### [KDE](https://kde.org)

> I am also working on including some custom configurations for my favorite desktop environment, [Plasma](https://kde.org/plasma-desktop/), made by the good folks at the KDE Team. With this inclusion, you will be able to select between our **ashWM** window manager and custom **Plasma** desktop easily in your SDDM session manager. 
