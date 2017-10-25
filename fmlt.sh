#!/bin/bash

### Basic tools and configuration ###

sh main.sh

## ssh key pair
if [ ! -e ~/.ssh/id_rsa.pub ]
then
	ssh-keygen -t rsa -C "facundo.munoz@cirad.fr" -b 4096
fi

## Dotfiles
# paste the contents of ~/.ssh/id_rsa.pub into https://gitlab.com/profile/keys
git clone git@gitlab.com:famuvie/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git checkout fmlt
make stow-all    # update all dotfiles with local versions (if there are) and make links
git checkout -- .  # reset to dotfile versions in the repo
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


## Better off, if $bkploc contains .thunderbird, .mozilla, lib and VirtualBox\ VMs
## just copy everything with
## the trailing slash is necessary to copy the hidden directories
## in part. do not use a * at the end, as it does not match .dirname
rsync -azv $bkploc/ ~


### Software not installed in main.sh ###


### Close connection
sudo umount mnt


## Restore Work folder from fmhm sync
mkdir Work
unison fmhm 

## Setup hamster's time-tracking database
cd Work/logistica/Cirad/time-tracking
make
