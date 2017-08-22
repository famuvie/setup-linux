#!/bin/bash

### Basic tools and configuration ###

sh main.sh

## Dotfiles
git clone git@gitlab.com:famuvie/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git checkout fmlt
make stow-all
cd

### Restore personal settings from backup ###
#sshfs bayesiano:backups/fmoffacu mnt/
sshfs 192.168.0.2: mnt
bkploc='~/mnt'


# Okular pdf annotations
# Going through Unison config profile
#cp -r $bkploc/.kde/share/apps/okular/* .kde/share/apps/okular/

# Calibre configuration
# Going through Unison config profile
#cp -r $bkploc/.config/calibre ~/.config

### eMail and firefox profiles
cp -r $bkploc/.thunderbird ~
cp -r $bkploc/.mozilla/firefox ~

### R library (and possibly other libs)
cp -r $bkploc/lib ~

### Virtualbox VMs
rsync -azv --progress 192.168.0.2:/media/facu/Toshiba1T/VirtualBox\ VMs ~

### ~/bin
#cp -r $bkploc/bin ~


### Software not installed in main.sh ###


### Close connection
sudo umount mnt


## Restore Work folder from fmhm sync
mkdir Work
unison Work 
