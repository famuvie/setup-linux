#!/bin/bash

# Code name of Mint/Ubuntu
codename=`lsb_release -sc`

# System architecture
arch=`lscpu | grep Architecture: | sed  's/Architecture\: *//g' -`

# Whether this is Mint or Ubuntu
if [ `lsb_release -si`=='LinuxMint' ];
    then
        mint=true;
fi

# Mint and Ubuntu correspondence
# https://en.wikipedia.org/wiki/Linux_Mint_version_history
# https://en.wikipedia.org/wiki/Ubuntu_version_history
if [ $mint ];
    then
	ubuntu_codename=`awk -F "=" '/CODENAME/{print $2}' /etc/upstream-release/lsb-release`;
fi


###########################
### Set up repositories ###
###########################


# LaTeX ##
# There is no PPA for texlive

# GIS software (Ubuntugis)
# unstable, because of a problem between GRASS and wxpython
# currently installing GIS software from official repositories. No need for more.
# sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable

# R-project
## add the signing key (by Michael Rutter) for these repos
## To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
## Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
## add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $ubuntu_codename-cran40/"

## Oracle (Sun) Java (JRE and JDK)
## It's a Gephi (and a common) dependency
## This is discontinued due to a change in the licensing of Oracle JDK
## sudo add-apt-repository ppa:webupd8team/java

## Backup
## Timeshift (system backup and restore utility)
## http://www.teejeetech.in/p/timeshift.html
## This is now installed by default in Mint
## sudo apt-add-repository -y ppa:teejee2008/ppa
## Back in Time (system and data backup. Based on rsnapshot)
## sudo add-apt-repository ppa:bit-team/stable
## Déjà Dup (system and data backup. Encrypted. Based on duplicity)

## Gephi: Graph Viz interactive visualization
## I don't want a daily build!
## Install the latest stable release in the next section
#sudo add-apt-repository ppa:rockclimb/gephi-daily

## Getdeb project repo
## http://www.getdeb.net/
## some packages from here (like freemind)
## now questioning the need for this
# sudo bash -c "echo 'deb http://archive.getdeb.net/ubuntu' $ubuntu_codename 'apps' > /etc/apt/sources.list.d/getdeb-$ubuntu_codename.list"
# wget -q -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -

## freemind repo
## http://freemind.sourceforge.net/
## Repo no longer maintained by Eric Lavarde. It is now available as a snap package.
## sudo bash -c "echo 'deb http://eric.lavar.de/comp/linux/debian/' 'unstable/' > /etc/apt/sources.list.d/freemind-debian.list"
## sudo bash -c "echo 'deb http://eric.lavar.de/comp/linux/debian/' 'ubuntu/' >> /etc/apt/sources.list.d/freemind-debian.list"
## wget -O - http://eric.lavar.de/comp/linux/debian/deb_zorglub_s_bawue_de.pubkey | sudo apt-key add -

## Not working with the current Mint version
## Installation delayed for now.
# sudo aptitude -r install snapd
# sudo snap install freemind

## sublime text (stable)
## Now available in repos
## wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
## echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

## ulauncher
sudo add-apt-repository ppa:agornostal/ulauncher

# Update repository information
sudo apt-get update



########################
### Install software ###
########################

## Basic tools
if [ ! $mint ];
	sudo apt-get install aptitude
fi

# Warning unattended installation of all these with aptitude broke my cinnamon installation (some incompatibility in dependencies)
# However, it seems not to happen with apt-get, so it looks safer for the moment.
# As an alternative, it might be useful to use aptitude-robot
# packages no longer available:
# gnome-do gnome-do-plugins gtg pdfshuffler 
sudo apt-get install apt-transport-https ccache csvkit guake gimp gparted htop keepass2 unison unison-gtk gftp libssl-dev meld playonlinux virtualbox virtualbox-qt umbrello recode ssh sshfs okular audacity pandoc pandoc-citeproc xdotool xournal ispell xclip git-all timeshift tmux stow zsh

# Gnome-do became really complicated to install under Mint
# https://www.linuxcapable.com/how-to-install-gnome-41-desktop-on-linux-mint-20/
# Check for an alternative launcher
# ulauncher looks good https://ulauncher.io/
sudo apt install ulauncher

# Clipboard manager
sudo aptitude -r install copyq


## MS fonts
sudo aptitude -r install ttf-mscorefonts-installer

# Other precompiled software as snap packages:
# sudo snap install freemind
# sudo snap install pdftk
# sudo snap install --classic skype

# Mind mapping
# Replace freemind by Minder (distributed as a flatpak package)
# Imports from Freemind
# https://github.com/phase1geo/Minder
sudo flatpak install Minder

# PDF tools
sudo flatpak install pdfchain

# Messaging
sudo flatpak install Skype
sudo flatpak install telegram

# Git interface
sudo flatpak install gitahead

# Mattermost desktop
sudo flatpak install mattermost

# VSCodium
sudo flatpak install VSCodium

# Getting Things Gnome!
# https://wiki.gnome.org/Apps/GTG
sudo flatpak install gtg

# Hamster time tracker
# https://github.com/projecthamster/hamster/wiki
sudo aptitude -r install hamster-time-tracker

# Sublime Text
sudo aptitude install sublime-text


# Oracle Java 8 (JDK and JRE)
# sudo aptitude -r install oracle-java8-installer

# Calibre e-book manager (latest binary installation from webpage)
# better install from official repo
#sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
sudo aptitude -r install calibre

# Multimedia (For Ubuntu)
if [ ! $mint ];
  then
    # Flash, Java and MP3 support
    sudo aptitude -ry install ubuntu-restricted-extras;
    # Encripted DVD support
    sudo aptitude -ry install libdvdread4 && sudo /usr/share/doc/libdvdread4/install-css.sh;
    # medibuntu repos
    sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$codename.list;
    sudo apt-get --quiet update;
    sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring;
    sudo apt-get --quiet update;

    sudo apt-get install app-install-data-medibuntu apport-hooks-medibuntu;
    sudo apt-get install w32codecs libdvdcss2 non-free-codecs;   # 32 bits
fi

# TeXLive (latest)
# Full install with default options except:
#  - only english and spanish documentation
#  - make symbolic links in system directories
# It takes a while (some 40 minutes)
# Easier to install texlive-full from official repos
#wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
#tar -xf install-tl-unx.tar.gz
#rm install-tl-unx.tar.gz
#cd install-tl-*
#sudo aptitude -ry install perl-tk # only needed for a gui install
#sudo ./install-tl -profile ../texlive.tlpdb
#tlversion=`grep -o 201. release-texlive.txt`
#sudo bash -c "echo -e '\n# LaTeX\nexport MANPATH=/usr/local/texlive/'$tlversion'/texmf-dist/doc/man/:\$MANPATH\nexport INFOPATH=/usr/local/texlive/'$tlversion'/texmf-dist/doc/info/:\$INFOPATH\nexport PATH=/usr/local/texlive/'$tlversion'/bin/'$arch'-linux/:\$PATH' >> /etc/profile"
#cd ..
#rm -r install-tl-*
# Still needed from repos:
#sudo aptitude install -ry tex-common texinfo lmodern perl-tk
sudo aptitude -ry install texlive-full perl-tk

# Command for further updating in the future
# sudo tlmgr update --all

# Core R, recommended and development packages (for compilation of sources)
sudo aptitude -ry install r-base r-base-dev r-recommended

# Bridge to the System Package Manager (bspm)
# https://enchufa2.github.io/bspm/
sudo add-apt-repository ppa:marutter/rrutter4.0   # R v4.0 and higher
sudo add-apt-repository ppa:c2d4u.team/c2d4u4.0+  # R packages
sudo apt-get update && sudo apt-get install python3-{dbus,gi,apt}
sudo Rscript -e 'install.packages("bspm", repos="https://cran.r-project.org")'

## Libraries needed for specific packages
sudo aptitude -r install libudunits2-dev  # units
sudo aptitude -r install libfontconfig1-dev  # systemfonts
sudo aptitude -r install libcairo2-dev  # gdtools
sudo aptitude -r install libxt-dev libgtk2.0-dev  # Cairo
# sudo aptitude -r install libv8-dev libjq-dev libprotobuf-dev protobuf-compiler  # geojsonio



# Other precompiled R-packages
sudo aptitude -ry install ggobi # r-cran-rggobi

# RStudio (latest version)
wget http://www.rstudio.org/download/desktop
rsversion=`grep -Eo -m1 '[[:digit:]]{4}\\.[[:digit:]]{2}\\.[[:digit:]]+-[[:digit:]]+' desktop`
rm desktop
case $arch in
	i386)
		rsarch=$arch;;
	*)
		rsarch='amd64'
esac


rsfname=rstudio-$rsversion-$rsarch.deb
wget https://download1.rstudio.org/desktop/$ubuntu_codename/$rsarch/$rsfname
sudo gdebi -n $rsfname
rm $rsfname

# Quarto (latest version)
# I could not scrape the filename for the latest version
# It is computed with JavaScript at rendering time.
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.0.38/quarto-1.0.38-linux-amd64.deb
sudo gdebi -n *.deb


# Geographical libraries GDAL and Proj4
sudo aptitude -ry install libgdal-dev libproj-dev


# Gephi: Graph Viz interactive visualization 
# https://gephi.org/
# This is the latest release up to date.
# Moved to GitHub
# wget https://launchpad.net/gephi
wget https://gephi.org/users/download/
gephifile=`grep -m 1 -o http.*tar.gz index.html`
rm index.html
wget $gephifile
mkdir -p ~/bin
tar -C ~/bin -xf gephi-*
rm gephi-*
# TODO: put shortcut in Gnome menus


# Dropbox
# Latest version
wget https://linux.dropbox.com/packages/ubuntu/
case $arch in
	i386)
		dbarch=$arch;;
	*)
		dbarch='amd64'
esac

dbsuffix=`grep -o dropbox[_\.0-9]*$dbarch.deb index.html | tail -1`
wget https://linux.dropbox.com/packages/ubuntu/$dbsuffix
rm index.html
sudo aptitude -r install libpango1.0-0  # dependency
sudo dpkg -i dropbox*
rm dropbox*
sudo aptitude -r install nemo-dropbox


# yEd graph editor
#http://www.yworks.com/en/products_yed_download.html


## Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


## Zotero
## Config the data-directory to point to ~/Work/logistica/Zotero
sudo flatpak install zotero

## Better BibTex for Zotero extension
## https://retorque.re/zotero-better-bibtex/installation/
wget https://github.com/retorquere/zotero-better-bibtex/releases/latest
bbtfile=`grep -m 1 -o 'zotero[-a-z0-9\.]*xpi' latest`
vnumber=`echo $bbtfile | grep -o -P '[\d\.]*(?=\.)'`
rm latest
wget https://github.com/retorquere/zotero-better-bibtex/releases/download/v$vnumber/$bbtfile
## Manually install the extension from Zotero
## Tools > Add-ons > Extensions > Gear (top-right) > Install Add-on From File... Choose downloaded .xpi and install.
## Close Zotero and remove file.

## PubPeer Zotero extension
wget https://objects.githubusercontent.com/github-production-release-asset-2e65be/192403061/62ee0641-8842-47b0-820b-f88b559e4504?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20221109%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221109T095427Z&X-Amz-Expires=300&X-Amz-Signature=634fec0fef9bf38500ea0b5efdf3640784930fd5c97a20193f13d8299065dc68&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=192403061&response-content-disposition=inline%3B%20filename%3Dzotero-pubpeer-0.0.14.xpi&response-content-type=application%2Fx-xpinstall
## Manually install the extension from Zotero

###########################
### More specific tools ###
###########################

# athens knowledge base (for reading notes)
# It's an Appimage file within work/bin, and the data are in work/logistica/notes_athens (backed up)
# This is no longer maintained. Moved to Logseq now.
sudo flatpak install logseq

# pomodoro Applet
# Linux Mint applet (search and install)

# Typora
# https://typora.io/
# wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
# sudo add-apt-repository 'deb https://typora.io/linux ./'
# sudo apt-get update
# sudo apt-get install typora


# Nextcloud
sudo aptitude -r install nextcloud-desktop


# Mega sync

# OBS Studio

# CopyQ clipboard manager
# Configure to ignore text copied from KeePass
# https://copyq.readthedocs.io/en/latest/faq.html#faq-ignore-password-manager
sudo aptitude -r install copyq 

## OnlyOffice
sudo flatpak install onlyoffice

## Gnote
sudo aptitude -r install gnote


## Keybase
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install ./keybase_amd64.deb
rm keybase_amd64.deb


## Mega Sync with nemo extension
curl --remote-name https://mega.nz/linux/repo/xUbuntu_22.04/amd64/megasync-xUbuntu_22.04_amd64.deb
sudo apt install ./megasync-xUbuntu_22.04_amd64.deb
rm megasync-xUbuntu_22.04_amd64.deb
curl --remote-name https://mega.nz/linux/repo/xUbuntu_20.04/amd64/nemo-megasync-xUbuntu_20.04_amd64.deb
sudo apt install ./nemo-megasync-xUbuntu_20.04_amd64.deb
rm nemo-megasync-xUbuntu_20.04_amd64.deb

## Docker
sudo aptitude -r install docker.io
sudo usermod -aG docker facu  # add user to docker group to run docker without sudo. Login into a new terminal for this to take effect.

# zoom-us-wrapper
# https://github.com/mdouchement/docker-zoom-us
# Run with: zoom-us-wrapper zoom at the command line
docker pull mdouchement/zoom-us:latest  # pull docker image from dockerhub
docker run -it --rm --volume /usr/local/bin:/target mdouchement/zoom-us:latest install # install the wrapper scripts

## MS Teams
sudo flatpak install microsoft.teams


## z script directory jumper
## https://github.com/rupa/z
## The dot file is handled with dotfiles
wget https://github.com/rupa/z/archive/refs/heads/master.zip
unzip master.zip -d Work/bin
rm master.zip

## radian
sudo aptitude -r install python3-pip
pip3 install -U radian


## UHK Agent
wget https://github.com/UltimateHackingKeyboard/agent/releases/download/v2.0.1/UHK.Agent-2.0.1-linux-x86_64.AppImage
mv UHK.Agent-2.0.1-linux-x86_64.AppImage ~/.local/bin
chmod 774 .local/bin/UHK.Agent-2.0.1-linux-x86_64.AppImage
## Make a menu shortcut


#############
### Fonts ###
#############

## Mozilla Fira Fonts
## (used for instance in Beamer's m theme)
## taken from:
## https://stevescott.ca/2016-10-20-installing-the-fira-font-in-ubuntu.html

wget https://github.com/bBoxType/FiraSans/archive/master.zip
unzip master.zip
sudo mkdir -p /usr/share/fonts/opentype/fira
sudo mkdir -p /usr/share/fonts/truetype/fira
sudo find FiraSans-master/ -name "*.otf" -exec cp {} /usr/share/fonts/opentype/fira/ \;
sudo find FiraSans-master/ -name "*.ttf" -exec cp {} /usr/share/fonts/truetype/fira/ \;

## JetBrains Mono
## typeface for developers
## used in RStudio
## https://www.jetbrains.com/lp/mono/
sudo aptitude -r install fonts-jetbrains-mono

################################
### Settings and preferences ###
################################


## TODO:
## Configure guake to be run at the begining of the session and get the transparency right

# ## Default shell
# Done during installation
# chsh -s /bin/zsh

## alias ll = ls -l for Mint
# handled with dotfiles
# if [ $mint ];
#     then echo -e "alias ll='ls -Flh --group-directories-first'\nalias la='ll -a'" >> ~/.bashrc;
# fi

## Git config
## handled in the dotfile
# git config --global user.name "Facundo Muñoz"
# git config --global user.email "facundo.munoz@inra.fr"
# git config --global push.default simple


## Gnome-do

# In Gnome 3.x change the following entry in the file
# .gconf/apps/gnome-do/preferences/Do/Platform/Common/AbstractKeyBindingService/%gconf.xml
#	<entry name="Summon_Do" mtime="1334737421" type="string">
#		<stringvalue>&lt;Control&gt;&lt;Alt&gt;Return</stringvalue>
#	</entry>
# Unnecessary now

## CopyQ
rsync -azv --delete .config/copyq/ ~/.config/copyq




########################
### Cinnamon Applets ###
########################

# Install pomodoro timer

################
### Dotfiles ###
################

# Getting Things Gnome
# Set up bind mounts by appending the lines below into /etc/fstab
### Getting Things Gnome config files
#/home/facu/Work/logistica/gtg /home/facu/.var/app/org.gnome.GTG/data/gtg none bind,rw
#/home/facu/Work/logistica/gtg /home/facu/.var/app/org.gnome.GTG/config/gtg none bind,rw
## These get mounted owned by root initially. 
## Run once the line below to fix permanently.
# sudo chown -R facu:facu .var/app/org.gnome.GTG

######################
### Manual install ###
######################



#################
### Restoring ###
#################


## Run from the home dir at the back up
rsync -azv .dotfiles ~
cd ~/.dotfiles
## Make sure the git repository is in clean status
make  # This will stow all targets and create symlinks
git reset --hard # Reset the changed files in the git repository to previous state
cd -  # go back

rsync -azv .ssh ~
rsync -azv .unison ~
rsync -azv .thunderbird ~
rsync -azv .mozilla/firefox/ ~/.mozilla/firefox
rsync -azv .config/rstudio/ ~/.config/rstudio
rsync -azv .config/RStudio/ ~/.config/RStudio
rsync -azv .config/RStudio/ ~/.config/RStudio
rsync -azv .local/share/okular ~/.local/share/
rsync -azv .local/share/ulauncher ~/.local/share/
rsync -azv .config/ulauncher ~/.config
rsync -azv .z ~
rsync -azv lib/R/library ~/lib/R

## Linux mint web apps
rsync -azv .local/share/applications/webapp-* ~/.local/share/applications/
rsync -azv --mkpath --delete .local/share/ice/firefox/* ~/.local/share/ice/firefox/

## Firefox - UVEG
rsync -azv .local/share/applications/firefox-uveg.desktop ~/.local/share/applications/

## Mattermost profiles
rsync -azv --mkpath --delete .var/app/com.mattermost.Desktop ~/.var/app/

## GitAhead config
rsync -azv --delete .config/gitahead.com ~/.var/app/io.github.gitahead.GitAhead/config

## Calibre
rsync -azv --delete .config/calibre ~/.config

## Cinnamon config files
rsync -azv --delete .cinnamon ~

## dconf settings
## dconf is a binary database of config settings for gnome
## https://askubuntu.com/questions/22313/what-is-dconf-what-is-its-function-and-how-do-i-use-it
## How to recover settings from a backed up database:
## https://unix.stackexchange.com/questions/199836/how-can-i-view-the-content-of-a-backup-of-the-dconf-database-file/199864?newreg=edfd1243cf514ba790c110b131e3ac6c
cp .config/dconf/user ~/.config/dconf/olduser
printf %s\\n "user-db:olduser" > ~/db_profile
DCONF_PROFILE=~/db_profile dconf dump / > ~/old_settings
## You can now explore settings on the text file and use gsettings to reset some of the keys (e.g. wallpaper)
grep -A 3 desktop/background ~/old_settings
gsettings set org.cinnamon.desktop.background picture-uri 'file:///home/facu/Work/personal/img/wallpapers/abstract-technology-background.png'


####################
### Restore Work ###
####################
## Run from the home dir at the back up
rsync -azv Work ~

