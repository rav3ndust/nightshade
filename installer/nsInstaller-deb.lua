-- nightshade installer
--      by rav3ndust
-- Installs nightshade desktop packages and wiredWM.
-- Written for use on Debian/Ubuntu-based systems.
-- | | | *NOTE: This is the TESTING version of the script.* | | | 
-- ###################################################
local TITLE = "nightshade installer"
local VERSION = 0.1
local CHANNELS = {"Testing", "Development", "Stable"}
local dev_packages = {"git", "vim", "python3", "python3-pip", "python3-venv", "lua5.4", "fish", "htop", "filezilla"}
local base_packages = {"chromium", "torbrowser-launcher", "gpa", "telegram-desktop", "virtualbox-qt", "netsurf", "gnome-weather", "gnome-todo"}
local games = {"minetest", "nexuiz", "gnome-chess", "kcheckers", "aisleriot-solitaire", "openarena"}
-- ###################################################
-- Functions
-- ###################################################
function notify(notification_title, notification_description)
    -- sends a notification to the user.
    os.execute(string.format("notify-send '%s' '%s'", notification_title, notification_description))
end 
function sleep(seconds)
    -- halts system activities X seconds.
    os.execute("sleep "..seconds)
end
function refresh()
    -- refreshes system repositories using apt.
    local update_cmd = "sudo apt update"
    print("Updating system repositories...")
    sleep(1)
    os.execute(update_cmd)
end 
function pkg_installer(package)
    -- installs packages using apt.
    local install_cmd = "sudo apt install -y"
    print(string.format("Installing %s...", package))
    sleep(1)
    os.execute(install_cmd.." "..package)
    print(package.." installation has finished.")
end
function wiredWM_install_configure()
    -- installs and configures wiredWM, our i3 fork.
    -- TODO: finish setting up logic for this function.
    local wired_repo = "https://github.com/rav3ndust/wiredWM"
    local wired_pkgs = {"i3-wm", "i3lock-fancy", "rofi", "conky", "xscreensaver", "nitrogen", "arandr", "flameshot", "cmatrix", "cmus", "neofetch", "kitty"} 
    print("Installing and configuring wiredWM...")
    sleep(1)
    os.execute(string.format("git clone %s", wired_repo))
end
function main()
    -- main function.
end
-- ###################################################
-- Script entry point
-- ###################################################
main()
