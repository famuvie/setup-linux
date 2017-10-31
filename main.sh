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
	case $codename in
		lisa )					# Mint 12
			ubuntu_codename='oneiric';;	# Ubuntu 11.10
		maya )					# Mint 13
			ubuntu_codename='precise';;	# Ubuntu 12.04
		nadia )					# Mint 14
			ubuntu_codename='quantal';;	# Ubuntu 12.10
		olivia )				# Mint 15
			ubuntu_codename='raring';;	# Ubuntu 13.04
		petra )					# Mint 16
			ubuntu_codename='saucy';;	# Ubuntu 13.10
		qiana )					# Mint 17
			ubuntu_codename='trusty';;	# Ubuntu 14.04
		sonya )					# Mint 18.2
			ubuntu_codename='xenial';;	# Ubuntu 16.04
	esac
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
sudo bash -c "echo 'deb http://cran.r-project.org/bin/linux/ubuntu' $ubuntu_codename'/' > /etc/apt/sources.list.d/cran-r-ppa-$ubuntu_codename.list"
# gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 # (doesn't work?)
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9 | gpg -a --export E084DAB9 | sudo apt-key add -

## Oracle (Sun) Java (JRE and JDK)
## It's a Gephi (and a common) dependency
sudo add-apt-repository ppa:webupd8team/java

## Backup
## Timeshift (system backup and restore utility)
## http://www.teejeetech.in/p/timeshift.html
sudo apt-add-repository -y ppa:teejee2008/ppa
## Back in Time (system and data backup. Based on rsnapshot)
sudo add-apt-repository ppa:bit-team/stable
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
sudo bash -c "echo 'deb http://eric.lavar.de/comp/linux/debian/' 'unstable/' > /etc/apt/sources.list.d/freemind-debian.list"
sudo bash -c "echo 'deb http://eric.lavar.de/comp/linux/debian/' 'ubuntu/' >> /etc/apt/sources.list.d/freemind-debian.list"
wget -O - http://eric.lavar.de/comp/linux/debian/deb_zorglub_s_bawue_de.pubkey | sudo apt-key add -


## sublime text (stable)
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

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
sudo apt-get install apt-transport-https freemind guake gnome-do gnome-do-plugins gparted hamster-indicator htop keepass2 unison unison-gtk gftp meld playonlinux virtualbox virtualbox-qt umbrello pdftk recode ssh sshfs gtg okular audacity pdfshuffler pandoc pandoc-citeproc xdotool xournal ispell xclip git-all timeshift tmux stow zsh

# missing: skype

# Sublime Text
sudo aptitude install sublime-text


# Oracle Java 8 (JDK and JRE)
sudo aptitude -r install oracle-java8-installer

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

# RStudio (latest version)
wget http://www.rstudio.org/download/desktop
rsversion=`grep -m 1 -o '[[:digit:]][.][[:digit:]+][.][[:digit:]][[:digit:]][[:digit:]]*' desktop | head -n 1`
rm desktop
case $arch in
	i386)
		rsarch=$arch;;
	*)
		rsarch='amd64'
esac

wget http://download1.rstudio.org/rstudio-$ubuntu_codename-$rsversion-$rsarch.deb
sudo gdebi -n rstudio-$ubuntu_codename-$rsversion-i386.deb
rm rstudio-$ubuntu_codename-$rsversion-i386.deb

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
wget https://www.dropbox.com/install
case $arch in
	i386)
		dbarch=$arch;;
	*)
		dbarch='amd64'
esac

dbsufix=`grep -o /download?dl=packages/ubuntu/dropbox[_\.0-9]*$dbarch.deb install`
wget https://www.dropbox.com$dbsufix
rm install
sudo dpkg -i download*
rm download*
sudo aptitude -r install nemo-dropbox

# Delicious (Firefox plugin)
#wget https://addons.mozilla.org/firefox/downloads/file/172674/delicious_bookmarks-2.3.4-fx.xpi
#firefox delicious_bookmarks-2.3.4-fx.xpi

# yEd graph editor
#http://www.yworks.com/en/products_yed_download.html


## Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

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



### Bug corrections and workarounds ###

#	# rubber and epstopdf
#	# http://forums.linuxmint.com/viewtopic.php?f=47&t=49701
#	sudo cp /usr/share/rubber/rules.ini /usr/share/rubber/rules.ini.bak
#	sudo bash -c 'sed "s/= epstopdf/= bash epstopdf/" /usr/share/rubber/rules.ini.bak > /usr/share/rubber/rules.ini'
#	Seems solved now


