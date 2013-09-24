#!/bin/bash

### Restore personal settings from backup ###

# Execute ~/src/system.setup.sh


### Basic tools and configuration ###

sh main.sh


### Software not installed in main.sh ###
sudo aptitude -ry install amule sound-juicer
