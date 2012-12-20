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


###########################
### Set up repositories ###
###########################

# Bazaar version control
sudo add-apt-repository ppa:bzr/ppa

# LibreOffice (unnecessary for Mint)
if [ ! $mint ];
  then sudo add-apt-repository ppa:libreoffice/ppa;
fi

# LaTeX ##
# There is no PPA for texlive

# GIS software (Ubuntugis)
# unstable, por el problema de GRASS con wxpython
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable

# R-project
sudo bash -c "echo 'deb http://cran.r-project.org/bin/linux/ubuntu' $ubuntu_codename'/' > /etc/apt/sources.list.d/cran-r-ppa-$ubuntu_codename.list"
# gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 # (doesn't work?)
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9  gpg -a --export E084DAB9 | sudo apt-key add - 


## Gephi: Graph Viz interactive visualization
## I don't want a daily build! 
## Install the latest stable release in the next section
#sudo add-apt-repository ppa:rockclimb/gephi-daily

# Insync: Google Drive client for linux
wget -O - https://d2t3ff60b2tol4.cloudfront.net/services@insynchq.com.gpg.key | sudo apt-key add -
sudo bash -c "echo 'deb http://apt.insynchq.com/ubuntu' $ubuntu_codename' non-free' > /etc/apt/sources.list.d/insync-ppa-$ubuntu_codename.list"

# Update repository information
sudo apt-get update



########################
### Install software ###
########################

# Basic tools
sudo apt-get install aptitude 
sudo aptitude -ry install guake skype gnome-do unison unison-gtk gftp meld playonlinux virtualbox freemind pdftk umbrello recode sshfs gtg okular

# Calibre e-book manager (latest binary installation from webpage)
sudo python -c "import sys; py3 = sys.version_info[0] > 2; u = __import__('urllib.request' if py3 else 'urllib', fromlist=1); exec(u.urlopen('http://status.calibre-ebook.com/linux_installer').read()); main()"


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
# It takes a while
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xf install-tl-unx.tar.gz
rm install-tl-unx.tar.gz
cd install-tl-*
#sudo aptitude -ry install perl-tk # only needed for a gui install
sudo ./install-tl -profile ../texlive.tlpdb 
tlversion=`grep -o 201. release-texlive.txt`
sudo bash -c "echo -e 'export MANPATH=/usr/local/texlive/'$tlversion'/texmf/doc/man/:\$MANPATH\nexport INFOPATH=/usr/local/texlive/'$tlversion'/texmf/doc/info/:\$INFOPATH\nexport PATH=/usr/local/texlive/'$tlversion'/bin/i386-linux/:\$PATH' >> /etc/bash.bashrc"
cd ..
rm -r install-tl-*
# Command for further updating in the future
# sudo tlmgr update --all

# Core R, recommended and development packages (for compilation of sources)
sudo aptitude -ry install r-base r-base-dev r-recommended

# RStudio (latest version)
wget http://www.rstudio.org/download/desktop
rsversion=`grep -m 1 -o '[[:digit:]][.][[:digit:]][[:digit:]][.][[:digit:]][[:digit:]][[:digit:]]' desktop | head -n 1`
rm desktop
wget http://download1.rstudio.org/rstudio-$rsversion-i386.deb
sudo gdebi -n rstudio-$rsversion-i386.deb
rm rstudio-$rsversion-i386.deb

# gedit plugins
sudo aptitude -ry install gedit-developer-plugins gedit-plugins
  # watch out! the latex plugin installs LaTeX!!
  # We should install it beforehand (it does it anyway)
  # It also installs Bazaar.
  # gedit-developer-plugins requires gedit >= 3.2.0 
  # installing from source gave problems with libgedit.private.so.0 library not found
  # Do not auto-accept the first solution, which is not installing developer plugins
  # and take the second option, which is upgrading gedit
  sudo aptitude install gedit-developer-plugins

# gedit-latex-plugin ## TODO: fetch the latest version automatically
# This is difficult due to the gnome-3 issue.
# In ubuntu 11.10 repos there is a version that works only with gedit-2.x
# but Oneiric ships gedit-3.x. Need to install from
#https://launchpad.net/ubuntu/oneiric/i386/gedit-latex-plugin/3.3.1-1~oneiric1
#wget http://launchpadlibrarian.net/83566981/gedit-latex-plugin_3.3.1-1~oneiric1_all.deb
#sudo gdebi -n gedit-latex-plugin_3.3.1-1~oneiric1_all.deb
#rm gedit-latex-plugin_3.3.1-1~oneiric1_all.deb
# I think this is solved now
sudo aptitude -ry install gedit-latex-plugin
# Agghh!!! This reinstalls LaTeX!!!


# gedit-r-plugin
# in ubuntu 11.10 repositories there is a Gtk2 outdated version
# that don't work well, because 11.10 works with Gtk3.
# We need to install it from the website.
wget http://sourceforge.net/projects/rgedit/files/latest/download?source=files -O tmp_rgedit.tar.gz
#  # After installing the previous plugins this should be unnecessary (It is)
mkdir -p ~/.local/share/gedit/plugins/
tar -C ~/.local/share/gedit/plugins -xf tmp_rgedit.tar.gz
rm tmp_rgedit.tar.gz

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

# In Gnome 3.x the CLI is gsettings:
gsettings set org.gnome.gedit.plugins active-plugins "['latex', 'changecase', 'filebrowser', 'docinfo', 'wordcompletion', 'time', 'terminal', 'externaltools', 'multiedit', 'modelines', 'bracketcompletion', 'synctex', 'codecomment', 'spell', 'textsize', 'RCtrl']"

# gedit preferences
    # ancho del tabulador: 4
    # usar espacios en lugar de tabuladores
    # activar sangría automática
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
gsettings set org.gnome.gedit.preferences.editor auto-indent true


# Bazaar 
sudo aptitude -ry install bzr-explorer bzr-svn

# Geographical libraries GDAL and Proj4
sudo aptitude -ry install libgdal-dev libproj-dev

# Insync: Google Drive client for linux
#sudo apt-get install insync-beta-ubuntu
#sudo apt-get install insync-beta-gnome     # GNOME Shell
sudo aptitude -ry install insync-beta-cinnamon  # Cinnamon


# Gephi: Graph Viz interactive visualization
# This is the latest release up to date.
# TODO: infer automatically the latest release
wget https://launchpad.net/gephi/0.8/0.8.1beta/+download/gephi-0.8.1-beta.tar.gz
tar -C ~/bin -xf gephi-0.8.1-beta.tar.gz
rm gephi-0.8.1-beta.tar.gz


# Kompozer: web authoring  
# TODO: infer automatically the latest release
#wget http://sourceforge.net/projects/kompozer/files/current/0.8b3/linux-i686/kompozer-0.8b3.es-ES.gcc4.2-i686.tar.gz/download
wget http://archive.ubuntu.com/ubuntu/pool/universe/k/kompozer/kompozer_0.8~b3.dfsg.1-0.1ubuntu2_i386.deb http://archive.ubuntu.com/ubuntu/pool/universe/k/kompozer/kompozer-data_0.8~b3.dfsg.1-0.1ubuntu2_all.deb
sudo dpkg -i kompozer*.deb
rm kompozer*.deb


################################
### Settings and preferences ###
################################


## TODO: 
## Configure guake to be run at the begining of the session and get the transparency right

## alias ll = ls -l for Mint
if [ $mint ];
    then echo -e "alias ll='ls -Flh'\nalias la='ls -Flah'" >> ~/.bashrc;
fi
    

## Gnome-do

# TODO: In Gnome 3.x change the following entry in the file
# .gconf/apps/gnome-do/preferences/Do/Platform/Common/AbstractKeyBindingService/%gconf.xml
#	<entry name="Summon_Do" mtime="1334737421" type="string">
#		<stringvalue>&lt;Control&gt;&lt;Alt&gt;Return</stringvalue>
#	</entry>



### Bug corrections and workarounds ###

# rubber and epstopdf
# http://forums.linuxmint.com/viewtopic.php?f=47&t=49701
sudo cp /usr/share/rubber/rules.ini /usr/share/rubber/rules.ini.bak
sudo bash -c 'sed "s/= epstopdf/= bash epstopdf/" /usr/share/rubber/rules.ini.bak > /usr/share/rubber/rules.ini'


