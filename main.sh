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


