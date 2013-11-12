dotfiles
========
My various dotfiles collected over the years from various places across the interweb.

###How to use###
Clone the repo and symlink the files/folders you want to use.

Example:

 ```bash
$ git clone git@github.com:Edholm/dotfiles.git  
$ cd dotfiles  
$ git submodule init     # To fetch the vimrc submodule
$ git submodule update
$ ln -s bashrc ~/.bashrc
$ ln -s xinitrc ~/.xinitrc
$ ln -s i3 ~/.i3
# Etc.
```

###i3###
I use [i3](https://www.archlinux.org/packages/community/x86_64/i3-wm/) with [i3bar-icons-git](https://aur.archlinux.org/packages/i3bar-icons-git/). 
I modified the icon patch to not add spacing after the icons. This makes using only icons a bit nicer.

For status output I use [py3status-git](https://aur.archlinux.org/packages/py3status-git/) with my own custom modules.
#### Screenshot####
Statusbar on AC-power and low CPU usage:  
![Statusbar](screenshots/2013-11-12-statusbar.png "i3bar-icon, i3status and py3status")  
Statusbar on battery and high CPU usage (CPU usage only shows when above certain threshold)  
![Statusbar](screenshots/2013-11-12-statusbar-battery.png "i3bar-icon, i3status and py3status")  

(Note: The below screenshots use _conky_ as status output command)  
My desktop as of 2013-11-09:

![i3, urxvt and custom conkyrc as status feeder](2013-11-09-i3-busy.png "Busy")
![Clean desktop](screenshots/2013-11-09-i3-clean.png "Clean")
On battery (patched i3bar that can show xbm icons)
![On battery](screenshots/2013-11-09-i3-battery.png "On battery")

