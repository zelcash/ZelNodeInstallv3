#!/bin/bash

###### you must be logged in as a sudo user, not root #######
# This script will update your ZelNode daemon to the current release
# Version ZelNodeUpdate v4.0

#wallet information
COIN_NAME='zelcash'
COIN_DAEMON='zelcashd'
COIN_CLI='zelcash-cli'
COIN_PATH='/usr/local/bin'
USERNAME=$(who -m | awk '{print $1;}')
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RED='033[1;31m'
NC='\033[0m'
STOP='\e[0m'
#end of required details

#Display script name and version
clear
echo -e "${YELLOW}=================================================================="
echo -e "ZelNode Update, v4.0"
echo -e "==================================================================${NC}"
echo -e "${BLUE}23 June 2019, by Alttank fam, dk808, Goose-Tech & Skyslayer${NC}"
echo -e
echo -e "${CYAN}ZelNode update starting, press [CTRL-C] to cancel.${NC}"
sleep 3
echo -e
#check for correct user
USERNAME=$(who -m | awk '{print $1;}')
echo -e "${CYAN}You are currently logged in as ${GREEN}$USERNAME${CYAN}.\n\n"
read -p 'Was this the username used to install the ZelNode? [Y/n] ' -n 1 -r
if [[ $REPLY =~ ^[Nn]$ ]]
then
    echo ""
    echo -e "${YELLOW}Please log out and login with the username you created for your ZelNode.${NC}"
      exit 1
fi
#check for root and exit with notice if user is root
ISROOT=$(whoami | awk '{print $1;}')
if [ "$ISROOT" = "root" ]; then
    echo -e "${CYAN}You are currently logged in as ${RED}root${CYAN}, please log out and log back in with as your sudo user.${NC}"
    exit
fi
sleep 2

#Closing zelcash daemon
echo -e "${YELLOW}Stopping daemon...${NC}"
sudo systemctl stop zelcash > /dev/null 2>&1 && sleep 3
sudo $COIN_CLI stop > /dev/null 2>&1 && sleep 5
sudo killall $COIN_DAEMON > /dev/null 2>&1

#Updating zelcash package
echo -e "${GREEN}Upgrading Zelcash package...${NC}"
sudo apt-get update -y
sudo apt-get install --only-upgrade zelcash -y
sudo chmod 755 /usr/local/bin/zelcash*
sleep 2

#Notice to user we are complete and request a reboot
echo -e "${GREEN}Update complete. Please reboot the VPS by typing: ${CYAN}sudo reboot -n"
echo -e "${GREEN}Then verify the ZelCash daemon has started by typing: ${CYAN}zelcash-cli getinfo${NC}"
