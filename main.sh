#!/bin/bash

ubuntu_codename=`lsb_release -sc`

### Install basic tools ###

apt-get install aptitude



### Set up repositories ###

# Bazaar version control
sudo add-apt-repository ppa:bzr/ppa

# LibreOffice
sudo add-apt-repository ppa:libreoffice/ppa

# LaTeX ##
# There is no PPA for texlive

# GIS software (Ubuntugis)
# unstable, por el problema de GRASS con wxpython
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable

# R-project
sudo echo 'deb http://cran.r-project.org/bin/linux/ubuntu' $ubuntu_codename '/' > /etc/apt/sources.list.d/cran-r-ppa-$ubuntu_codename.list
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 gpg -a --export E084DAB9 | sudo apt-key add - 


# Update repository information
sudo aptitude update




### Install software ###

# TeXLive (latest)
# Full install with default options except:
#  - only english and spanish documentation
#  - make symbolic links in system directories
# It takes a while
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xf install-tl-unx.tar.gz
rm install-tl-unx.tar.gz
cd install-tl-*
sudo aptitude -ry install perl-tk 
sudo ./install-tl -profile ../texlive.tlpdb 
tlversion=`grep -o 201. install-tl.log`
sudo bash -c "echo -e 'export MANPATH=/usr/local/texlive/'$tlversion'/texmf/doc/man/:\$MANPATH\nexport INFOPATH=/usr/local/texlive/'$tlversion'/texmf/doc/info/:\$INFOPATH\nexport PATH=/usr/local/texlive/'$tlversion'/bin/i386-linux/:\$PATH' >> /etc/bash.bashrc"
cd ..
rm -r install-tl-*
# Command for further updating in the future
# sudo tlmgr update --all

# Core R, recommended and development packages (for compilation of sources)
sudo aptitude -ry install r-base r-base-dev r-recommended

# RStudio
wget http://download1.rstudio.org/rstudio-0.94.110-i386.deb
sudo gdebi -n rstudio-0.94.110-i386.deb
rm rstudio-0.94.110-i386.deb

# gedit plugins
sudo aptitude -ry install gedit-developer-plugins gedit-plugins
  # watch out! the latex plugin installs LaTeX!!
  # We should install it beforehand

# gedit-latex-plugin
# In ubuntu 11.10 repos there is a version that works only with gedit-2.x
# but Oneiric ships gedit-3.x. Need to install from
#https://launchpad.net/ubuntu/oneiric/i386/gedit-latex-plugin/3.3.1-1~oneiric1
wget http://launchpadlibrarian.net/83566981/gedit-latex-plugin_3.3.1-1~oneiric1_all.deb
sudo gdebi -n gedit-latex-plugin_3.3.1-1~oneiric1_all.deb
rm gedit-latex-plugin_3.3.1-1~oneiric1_all.deb

# gedit-r-plugin
# in ubuntu 11.10 repositories there is a Gtk2 outdated version
# that don't work well, because 11.10 works with Gtk3.
# We need to install it from the website.
wget http://sourceforge.net/projects/rgedit/files/latest/download?source=files -O tmp_rgedit.tar.gz
#  # After installing the previous plugins this should be unnecessary
mkdir -p .local/share/gedit/plugins/
cd .local/share/gedit/plugins
tar -xf ~/tmp_rgedit.tar.gz
rm ~/tmp_rgedit.tar.gz

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

# GDAL and Proj4
sudo aptitude -ry install libgdal-dev libproj-dev
