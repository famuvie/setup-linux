#!/bin/bash

### Basic tools and configuration ###

sh main.sh


### Restore personal settings from backup ###
sshfs bayesiano:backups/fmoffacu mnt/
bkploc='~/mnt'

# Unison profiles
cp -p $bkploc/.unison/*.prf .unison

# Okular pdf annotations
# Going through Unison config profile
#cp -r $bkploc/.kde/share/apps/okular/* .kde/share/apps/okular/

# Calibre configuration
# Going through Unison config profile
#cp -r $bkploc/.config/calibre ~/.config

### eMail
cp -r $bkploc/.thunderbird ~

### R library (and possibly other libs)
cp -r $bkploc/lib ~

### ~/bin
cp -r $bkploc/lib ~



### Software not installed in main.sh ###
