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

## Check whether this is still a problem
## Fix issue with RStudio and the Nouveau Nvidia driver
## https://github.com/rstudio/rstudio/issues/3781
#echo "QT_XCB_FORCE_SOFTWARE_OPENGL=1 /usr/lib/rstudio/bin/rstudio" > ~/bin/rstudio
#chmod +x ~/bin/rstudio
#sudo sed -i 's/\/usr\/lib\/rstudio\/bin\/rstudio/QT_XCB_FORCE_SOFTWARE_OPENGL=1 \/usr\/lib\/rstudio\/bin\/rstudio/' /usr/share/applications/rstudio.desktop

# Eclipse IDE + StatET
# Follow instructions from 
# http://www.stanford.edu/~messing/ComputationalSocialScienceWorkflow.html
# Download the CDT version of Eclipse (with tools for C/C++)
# wget http://www.eclipse.org/downloads/
# eclipsemirror=`grep -m 1 -o www.*.cpp*tar.gz index.html`
# wget $eclipsemirror'&mirror_id=514'
# wget `grep -m 1 -o 'http.*tar.gz' download*`
# mv eclipse* ~/bin
# tar -xf ~/bin/eclipse*
# mv ~/bin/eclipse ~/bin/Eclipse
# ln -s ~/bin/Eclipse/eclipse ~/bin/eclipse
# # Until 2012 Eclipse needed the java 6 version from Sun
# # sudo aptitude -ry install sun-java6-jre sun-java6-jdk
# # From 2013, Sun java if Oracle's java with a more restricted license
# # so it can't be installed from repos. However, Eclipse seems too
# # work fine with Open Java 7, now.
# sudo aptitude -ry install default-jdk
# # StatET
# # Install manually from within Eclipse:
# # http://www.walware.de/goto/statet
# sudo R CMD javareconf


# Mint replaced gedit by xed as the default text editor
# I could reinstall gedit, but I'm not using it so often as before
# I will rely on Sublime Text/Atom as powerful text editors
# and keep xed or whatever as is.
# # gedit plugins
# # sudo aptitude -ry install gedit-developer-plugins gedit-plugins
#   # watch out! the latex plugin installs LaTeX!!
#   # We should install it beforehand (it does it anyway)
#   # It also installs Bazaar.
#   # gedit-developer-plugins requires gedit >= 3.2.0
#   # installing from source gave problems with libgedit.private.so.0 library not found
#   # Do not auto-accept the first solution, which is not installing developer plugins
#   # and take the second option, which is upgrading gedit
#   sudo aptitude install gedit-developer-plugins

# # gedit-latex-plugin
# # In ubuntu 11.10 repos there is a version that works only with gedit-2.x
# # but Oneiric ships gedit-3.x. Need to install from
# #https://launchpad.net/ubuntu/oneiric/i386/gedit-latex-plugin/3.3.1-1~oneiric1
# #wget http://launchpadlibrarian.net/83566981/gedit-latex-plugin_3.3.1-1~oneiric1_all.deb
# #sudo gdebi -n gedit-latex-plugin_3.3.1-1~oneiric1_all.deb
# #rm gedit-latex-plugin_3.3.1-1~oneiric1_all.deb
# # This is solved now

# # This plugin depends on rubber who in turn depends on texlive
# # It doesn't know that I have already installed TeX Live and
# # wants to install the outdated version from de repos.
# # Solution is to build a dummy package to cheat him
# # Source: http://blogs.ethz.ch/ubuntu/2011/03/14/tex-live-2010-installation/
# sudo apt-get install equivs
# mkdir tl-equivs && cp texlive-local tl-equivs && cd tl-equivs
# equivs-build texlive-local
# sudo dpkg -i texlive-local_2013-1~1_all.deb
# cd .. && rm -r tl-equivs
# # Finally:
# sudo aptitude install gedit-latex-plugin

# # A workaround the latex-plugin who does not find texmf.cnf
# sudo ln -sf `kpsewhich -var-value TEXMFMAIN`/web2c/texmf.cnf /etc/texmf/texmf.cnf


# gedit-r-plugin
# Not maintaned any more.
# in ubuntu 11.10 repositories there is a Gtk2 outdated version
# that don't work well, because 11.10 works with Gtk3.
# We need to install it from the website.
# wget http://sourceforge.net/projects/rgedit/files/latest/download?source=files -O tmp_rgedit.tar.gz
#  # After installing the previous plugins this should be unnecessary (It is)
# mkdir -p ~/.local/share/gedit/plugins/
# tar -C ~/.local/share/gedit/plugins -xf tmp_rgedit.tar.gz
# rm tmp_rgedit.tar.gz
# All this is solved now
# (although the repos don't necessarily have the very latest version)
# sudo aptitude -ry install gedit-r-plugin

# Activate interesting plugins:
# - R integration (RCtrl)
# - Cambiar capitalización (changecase)
# - Comentar código (codecomment)
# - Completado de palabras (wordcompletion)
# - Completar paréntesis (bracketcompletion)
# - Herramientas externas (externaltools)
# - Multedición (multiedit)
# - SyncTeX (synctex)
# - Tamaño del texto (textsize)
# - Terminal empotrado (terminal)

# In Gnome 2.x I do it automatically editting
# .gconf/apps/gedit-2/plugins/%gconf.xml
# and using gconftool-2 as a CLI
#gconftool-2 --set /apps/gedit-2/plugins/active-plugins [latex,changecase,filebrowser,docinfo,wordcompletion,time,terminal,externaltools,multiedit,modelines,bracketcompletion,synctex,codecomment,spell,textsize,RCtrl] --type=list --list-type=string

# # In Gnome 3.x the CLI is gsettings:
# gsettings set org.gnome.gedit.plugins active-plugins "['latex', 'changecase', 'filebrowser', 'docinfo', 'wordcompletion', 'time', 'terminal', 'externaltools', 'multiedit', 'modelines', 'bracketcompletion', 'synctex', 'codecomment', 'spell', 'textsize', 'RCtrl']"

# # gedit preferences
#     # ancho del tabulador: 2
#     # usar espacios en lugar de tabuladores (seguro?)
#     # activar sangría automática
# gsettings set org.gnome.gedit.preferences.editor tabs-size 2
# gsettings set org.gnome.gedit.preferences.editor insert-spaces true
# gsettings set org.gnome.gedit.preferences.editor auto-indent true


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


# Kompozer: web authoring
# TODO: infer automatically the latest release
#wget kompozer.net
#grep -o http.*download index.html
##wget http://sourceforge.net/projects/kompozer/files/current/0.8b3/linux-i686/kompozer-0.8b3.es-ES.gcc4.2-i686.tar.gz/download
#wget http://archive.ubuntu.com/ubuntu/pool/universe/k/kompozer/kompozer_0.8~b3.dfsg.1-0.1ubuntu2_i386.deb http://archive.ubuntu.com/ubuntu/pool/universe/k/kompozer/kompozer-data_0.8~b3.dfsg.1-0.1ubuntu2_all.deb
#sudo dpkg -i kompozer*.deb
#rm kompozer*.deb

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


### Bug corrections and workarounds ###

#	# rubber and epstopdf
#	# http://forums.linuxmint.com/viewtopic.php?f=47&t=49701
#	sudo cp /usr/share/rubber/rules.ini /usr/share/rubber/rules.ini.bak
#	sudo bash -c 'sed "s/= epstopdf/= bash epstopdf/" /usr/share/rubber/rules.ini.bak > /usr/share/rubber/rules.ini'
#	Seems solved now

########################
### Cinnamon Applets ###
########################

# Install pomodoro timer

################
### Dotfiles ###
################

## Restore from backup
## Run from the home dir at the back up
rsync -azv .dotfiles ~
rsync -azv .ssh ~
rsync -azv .unison ~
rsync -azv .thunderbird ~
rsync -azv .mozilla/firefox/ ~/.mozilla/firefox
rsync -azv .config/rstudio/ ~/.config/rstudio
rsync -azv .config/RStudio/ ~/.config/RStudio
rsync -azv .config/RStudio/ ~/.config/RStudio
## Okular moved the metadata storage
rsync -azv .kde/share/apps/okular ~/.local/share/

## Linux mint web apps
rsync -azv .local/share/applications/webapp-* ~/.local/share/applications/
rsync -azv --delete .local/share/ice/firefox/* ~/.local/share/ice/firefox/
## Firefox - UVEG
rsync -azv .local/share/applications/firefox-uveg.desktop ~/.local/share/applications/

## Mattermost profiles (from manual install to flatpak config location)
rsync -azv --delete .config/Mattermost ~/.var/app/com.mattermost.Desktop/config

## GitAhead config (from manual install to flatpak config location)
rsync -azv --delete .config/gitahead.com ~/.var/app/io.github.gitahead.GitAhead/config

## Cinnamon config files
rsync -azv --delete .cinnamon ~

####################
### Restore Work ###
####################
## Run from the home dir at the back up
rsync -azv Work ~
