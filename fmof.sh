#!/bin/bash

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

### eMail
cp -r $bkploc/.thunderbird ~

### Software not installed in main.sh ###
