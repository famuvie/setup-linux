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

### eMail and firefox profiles
cp -r $bkploc/.thunderbird ~
cp -r $bkploc/.mozilla/firefox ~

### R library (and possibly other libs)
cp -r $bkploc/lib ~

### ~/bin
cp -r $bkploc/bin ~


### Software not installed in main.sh ###

#http://www.cytoscape.org/
#http://www.collab.net/products/giteyeapp
#http://www.opennx.net/
# in 64bit systems, solve this bug as explained:
# http://sourceforge.net/p/opennx/bugs/54/


### Firefox plugins:
# DownThemAll!
# feedly
# Shorten URL (bit.ly)
# Delicious Bookmarks (old version!!)
