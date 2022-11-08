Bash script for setting up my (Linux biostatistical) workstation from scratch

Sets repositories up, installs packages and plugins, and configures several things. Mostly, statistical packages and plugins. I use it for configuring a work station from scratch, and leave it ready to use with all the tools and settings I need. 


## How to use

This is a bash script.
Download and write in a terminal:
sh ./main.sh

But this is likely to fail at some point because things evolve fast. Better go through the script step by step. 

You can comment out the features you don't want installed.
You can also set executable permissions in order to run the script by double-clicking on it.
It will ask for administration provileges, but don't run the entire script with *sudo*.


## Details

main.sh is a shell script intended for setting up a statistical working environment in a Ubuntu/Mint machine.
It configures some repositories, installs some software (in special, software related with R and LaTeX) and configures some settings.
It also focus on some spatial/geographical software (GIS, GDAL, PROJ4, etc.).


*Repositories*
  * LibreOffice (default in Mint)
  * Ubuntugis (unstable repo)
  * R-project
  
*Software*
  * Core R, with recommended and development packages
  * Rstudio
  * git
  * GitAhead
  * docker
  * GDAL and PROJ4 (geospatial libraries)
  * Zotero
  * quarto
  * GNote
  * Mattermost, MS Teams, Zoom (dockerised)
  * keepass
  * MEGA Sync, Dropbox, keybase
  * OnlyOffice

*Plugins*
  * Better BibTex for Zotero

*Settings*
  * Mozilla Fira fonts, JetBrains mono
