#!/bin/bash

# Code name of Mint/Ubuntu
codename=`lsb_release -sc`

# Whether this is Mint or Ubuntu
if [ `lsb_release -si`=='LinuxMint' ]; 
    then 
        mint=true;
fi

# Mint and Ubuntu correspondence
if [ $mint ]; 
    then 
	case $codename in
		lisa )					# Mint 12
			ubuntu_codename='oneiric';;	# Ubuntu 11.10
		maya )					# Mint 13
			ubuntu_codename='precise';;	# Ubuntu 12.04
		nadia )					# Mint 14
			ubuntu_codename='quantal';;	# Ubuntu 12.10
		xxx )					# Mint 15
			ubuntu_codename='raring';;	# Ubuntu 13.04
	esac
fi

### Basic tools and configuration ###

sh main.sh


### Restore personal settings from backup ###
sshfs bayesiano:backups/fmoffacu mnt/
bkploc='~/mnt'

# Unison profiles
cp $bkploc/.unison/* .unison

# Okular pdf annotations
cp -r $bkploc/.kde/share/apps/okular/* .kde/share/apps/okular/

# Calibre configuration
cp -r $bkploc/.config/calibre ~/.config


### Software not installed in main.sh ###
