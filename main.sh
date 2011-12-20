#!/bin/bash
# Execute with root privileges (sudo)

ubuntu_codename=`lsb_release -sc`

### Install basic tools ###

apt-get install aptitude



### Set up repositories ###

# Bazaar version control
add-apt-repository ppa:bzr/ppa

# LibreOffice
sudo add-apt-repository ppa:libreoffice/ppa

# LaTeX ## TODO

# GIS software (Ubuntugis)
# unstable, por el problema de GRASS con wxpython
add-apt-repository ppa:ubuntugis/ubuntugis-unstable

# R-project
echo 'deb http://cran.r-project.org/bin/linux/ubuntu' $ubuntu_codename '/' > /etc/apt/sources.list.d/cran-r-ppa-$ubuntu_codename.list
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 gpg -a --export E084DAB9 | sudo apt-key add - 


# Update repository information
aptitude update




### Install software ###

# Core R, recommended and development packages (for compilation of sources)
aptitude -ry install r-base r-base-dev r-recommended

# gedit preferences
    # TODO: make automatically (?)
    # ancho del tabulador: 4
    # usar espacios en lugar de tabuladores
    # activar sangría automática
    
# gedit plugins
aptitude -ry install gedit-developer-plugins gedit-latex-plugin gedit-plugins
  # watch out! the latex plugin installs LaTeX!!
  # We should install it beforehand

# gedit-r-plugin
# in ubuntu 11.10 repositories there is a Gtk2 outdated version
# that don't work well, because 11.10 works with Gtk3.
# We need to install it from the website.
wget http://sourceforge.net/projects/rgedit/files/latest/download?source=files -O tmp_rgedit.tar.gz
#  # After installing the previous plugins this should be unnecessary
mkdir -p .local/share/gedit/plugins/
cd .local/share/gedit/plugins
tar -xf ~/tmp_rgedit.tar.gz

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
# TODO: do it automatically editting
# .gconf/apps/gedit-2/plugins/%gconf.xml
# (¿gconftool-2 sirve para eso?)

