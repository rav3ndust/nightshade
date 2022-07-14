'''
xWL.py
	- by rav3ndust

This is a simple Python script that makes sure we have a few things installed for: 
	- running X applications on Wayland
'''
import os as sh
import subprocess as sp 
# vars 
TITLE = "xWL - X11/Wayland Compatibility Script" 
welcome = "Welcome to the xWayland Compatibility Script. It will install xWayland on your system."
pkg = "xorg-xwayland"
notification = "xWayland installation has finished." 
user_options = ["1 - Install xWayland\n", "2 - Exit Script\n"]
usr_input = "Please input the digit corresponding to your choice now:\n"
# functions 
def sleep(seconds):
	# halts sys ops X seconds
	sh.system(f'sleep {seconds}')
def xWL_installation():
	# installs xWayland
	x = "Installing xWayland..."
	y = "xWayland has been installed." 
	print(x)
	sleep(1)
	sh.system(f'sudo pacman -Sy {pkg}')
	sleep(1)
	print(y)
	sleep(1)
def exitProg():
	# exits the script cleanly
	xit = "Exiting script..."
	print(xit)
	sleep(1)
	exit()
def err():
	# throws an error
	_errMsg1 = "Something went wrong." 
	_errMsg2 = "Please see above for logs." 
	_errNotif = "Please check terminal for logs." 
	print(_errMsg1)
	sleep(1)
	print(_errMsg2)
	sh.system(f'notify-send "{TITLE}" "{_errNotif}"')
	sleep(1)
	exitProg()
# script begins here
ready = "Here are your options:"
print(TITLE)
sleep(1)
print(welcome)
sleep(1)
print(ready)
sleep(1)
for opt in user_options:
	print(opt)
sleep(1)
CHOICE = input(user_input)
if CHOICE == 1:
	global opt
	opt = "Chosen option:"
	print(f'{opt} {user_options[1]}')
	sleep(1)
	xWL_installation()
else:
	exitProg()
'''
TODO: 
	- Testing.
	- Need to run on a new installation - preferably in a VM.
	- run some X11 applications under Wayland for testing.
'''
