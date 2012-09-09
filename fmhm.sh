#!/bin/bash

ubuntu_codename=`lsb_release -sc`

# Mint and Ubuntu correspondence
if [ `lsb_release -sc`=='lisa' ]; 
    then 
        mint=true;
        ubuntu_codename='oneiric'; 
fi


### Basic tools and configuration ###

sh main.sh


### Restore personal settings from backup ###

bkploc='/media/Backups/homefacu/facu'

# Unison profiles
cp $bkploc/.unison/* .unison

# Okular pdf annotations
cp -r /media/Backups/homefacu/facu/.kde/share/apps/okular/* .kde/share/apps/okular/

# Calibre configuration
cp -r /media/Backups/homefacu/facu/.config/calibre ~/.config

# aMule configuration
cp -r $bkploc/.aMule ~

### Software not installed in main.sh ###
sudo aptitude -ry install amule
