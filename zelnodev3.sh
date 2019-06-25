#!/bin/bash

#############################################################################################################################################################################
# IF PLANNING TO RUN ZELNODE FROM HOME/OFFICE/PERSONAL EQUIPMENT & NETWORK!!!
# You must understand the implications of running a ZelNode on your on equipment and network. There are many possible security issues. DYOR!!!
# Running a ZelNode from home should only be done by those with experience/knowledge of how to set up the proper security.
# It is recommended for most operators to use a VPS to run a ZelNode
#
#**Potential Issues (not an exhaustive list):**
#1. Your home network IP address will be displayed to the world. Without proper network security in place, a malicious person sniff around your IP for vulnerabilities to access your network.
#2. Port forwarding: The p2p port for ZelCash will need to be open.
#3. DDOS: VPS providers typically provide mitigation tools to resist a DDOS attack, while home networks typically don't have these tools.
#4. Zelcash daemon is ran with sudo permissions, meaning the daemon has elevated access to your system. **Do not run a ZelNode on equipment that also has a funded wallet loaded.**
#5. Static vs. Dynamic IPs: If you have a revolving IP, every time the IP address changes, the ZelNode will fail and need to be stood back up.
#6. Anti-cheating mechanisms: If a ZelNode fails benchmarking/anti-cheating tests too many times in the future, its possible your IP will be blacklisted and no nodes can not dirun using that public-facing IP.
#7. Home connections typically have a monthly data cap. ZelNodes will use 2.5 - 6 TB monthly usage depending on ZelNode tier, which can result in overage charges. Check your ISP agreement.
#8. Many home connections provide adequate download speeds but very low upload speeds. ZelNodes require 100mbps (12.5MB/s) download **AND** upload speeds. Ensure your ISP plan can provide this continually. 
#9. ZelNodes can saturate your network at times. If you are sharing the connection with other devices at home, its possible to fail a benchmark if network is saturated.
#############################################################################################################################################################################

#Version V3

###### you must be logged in as a sudo user, not root #######

COIN_NAME='zelcash'

#wallet information
WALLET_BOOTSTRAP='https://zelcore.io/zelcashbootstraptxindex.zip'
BOOTSTRAP_ZIP_FILE='zelcashbootstraptxindex.zip'
ZIPTAR='unzip'
CONFIG_FILE='zelcash.conf'
PORT=16125
SSHPORT=22
COIN_DAEMON='zelcashd'
COIN_CLI='zelcash-cli'
COIN_TX='zelcash-tx'
COIN_PATH='/usr/local/bin'
USERNAME=$(who -m | awk '{print $1;}')
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'
STOP='\e[0m'
FETCHPARAMS='https://raw.githubusercontent.com/zelcash/zelcash/master/zcutil/fetch-params.sh'
#end of required details
#
#
#

#countdown timer to provide outputs for forced pauses
#countdown "00:00:30" is a 30 second countdown
countdown()
(
  IFS=:
  set -- $*
  secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} ))
  while [ $secs -gt 0 ]
  do
    sleep 1 &
    printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
    secs=$(( $secs - 1 ))
    wait
  done
  echo -e "\033[1K"
)



#Suppressing password prompts for this user so zelnode can operate
sudo echo -e "$(who -m | awk '{print $1;}') ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo
clear
echo -e '\033[1;33m===============================================================================\033[0m'
echo -e 'ZelNode Setup, v3.0'
echo -e '\033[1;33m===============================================================================\033[0m'
echo -e '\033[1;34m23 Feb. 2019, by AltTank fam, dk808, Goose-Tech, Skyslayer, & Packetflow\033[0m'
echo -e
echo -e '\033[1;36mNode setup starting, press [CTRL-C] to cancel.\033[0m'
countdown "00:00:03"
echo -e

if [ "$USERNAME" = "root" ]; then
    echo -e "\033[1;36mYou are currently logged in as \033[0mroot\033[1;36m, please log out and\nlog back in with the username you just created.\033[0m"
    exit
fi
 
# searcch sshd conf file for ssh port if not default ask user for new port/
# set var SSHPORT by user imput if not default this is used for UFW firewall settings
searchString="Port 22"
file="/etc/ssh/sshd_config"
if grep -Fq "$searchString" $file ; then
    echo -e "SSH is currently set to the default port 22."
else
    echo -e "Looks like you have configured a custom SSH port..."
    echo -e
    read -p 'Enter your custom SSH port, or hit [ENTER] for default: ' SSHPORT
	  if [ -z "$SSHPORT" ]; then
      SSHPORT=22
    fi
fi
echo -e "\033[1;33mUsing SSH port:\033[1;32m" $SSHPORT
echo -e "\033[0m"
sleep 2

#get WAN IP ask user to verify it and or change it if needed 
WANIP=$(wget http://ipecho.net/plain -O - -q)
echo -e 'Detected IP Address is' $WANIP
echo -e
read -p 'Is IP Address correct? [Y/n] ' -n 1 -r
if [[ $REPLY =~ ^[Nn]$ ]]
then
    echo -e
    read -p 'Enter the IP address for your VPS, then hit [ENTER]: ' WANIP
fi

echo ""
echo -e "\033[1;33mEnter the MAINNET ZELNODE KEY generated by your ZelMate/ZelCore wallet: \033[0m"
read zelnodeprivkey

echo -e "\033[1;33m=======================================================\033[0m"
echo "INSTALLING ZELNODE DEPENDENCIES"
echo -e "\033[1;33m=======================================================\033[0m"
echo "Adding ZelCash Repos & Installing Packages..."
sleep 2
#adding ZelCash APT Repo
echo 'deb https://zelcash.github.io/aptrepo/ all main' | sudo tee --append /etc/apt/sources.list.d/zelcash.list > /dev/null
gpg --keyserver keyserver.ubuntu.com --recv 4B69CA27A986265D > /dev/null
gpg --keyserver keys.gnupg.net --recv 4B69CA27A986265D > /dev/null
gpg --keyserver eu.pool.sks-keyservers.net --recv 4B69CA27A986265D > /dev/null
gpg --export 4B69CA27A986265D | sudo apt-key add -
sudo apt-get update -y
#installing dependencies
sudo apt-get install software-properties-common -y
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nano htop pwgen ufw figlet -y
sudo apt-get install build-essential libtool pkg-config -y
sudo apt-get install libc6-dev m4 g++-multilib -y
sudo apt-get install autoconf ncurses-dev unzip git python python-zmq -y
sudo apt-get install wget curl bsdmainutils automake -y
sudo apt-get remove sysbench -y

echo -e "\033[1;33mPackages complete...\033[0m"
echo -e

if [ -f ~/.zelcash/zelcash.conf ]; then
    echo -e "\033[1;36mExisting conf file found, backing up to zelcash.old ...\033[0m"
    sudo mv ~/.zelcash/zelcash.conf ~/.zelcash/zelcash.old;
fi

RPCUSER=`pwgen -1 8 -n`
PASSWORD=`pwgen -1 20 -n`
if [ "x$PASSWORD" = "x" ]; then
    PASSWORD=${WANIP}-`date +%s`
fi
    echo -e "\n\033[1;32mCreating MainNet Conf File...\033[0m"
    sleep 3
    mkdir ~/.zelcash
    touch ~/.zelcash/$CONFIG_FILE
    echo "rpcuser=$RPCUSER" >> ~/.zelcash/$CONFIG_FILE
    echo "rpcpassword=$PASSWORD" >> ~/.zelcash/$CONFIG_FILE
    echo "rpcallowip=127.0.0.1" >> ~/.zelcash/$CONFIG_FILE
    echo "zelnode=1" >> ~/.zelcash/$CONFIG_FILE
    echo zelnodeprivkey=$zelnodeprivkey >> ~/.zelcash/$CONFIG_FILE
    echo "server=1" >> ~/.zelcash/$CONFIG_FILE
    echo "daemon=1" >> ~/.zelcash/$CONFIG_FILE
    echo "txindex=1" >> ~/.zelcash/$CONFIG_FILE
    echo "listen=1" >> ~/.zelcash/$CONFIG_FILE
    echo "logtimestamps=1" >> ~/.zelcash/$CONFIG_FILE
    echo "externalip=$WANIP" >> ~/.zelcash/$CONFIG_FILE
    echo "bind=$WANIP" >> ~/.zelcash/$CONFIG_FILE
    echo "addnode=explorer.zel.cash" >> ~/.zelcash/$CONFIG_FILE
    echo "addnode=explorer.zel.zelcore.io" >> ~/.zelcash/$CONFIG_FILE
    echo "addnode=explorer2.zel.cash" >> ~/.zelcash/$CONFIG_FILE
    echo "addnode=explorer.zelcash.online" >> ~/.zelcash/$CONFIG_FILE
    echo "addnode=node-eu.zelcash.com" >> ~/.zelcash/$CONFIG_FILE
    echo "addnode=node-uk.zelcash.com" >> ~/.zelcash/$CONFIG_FILE
    echo "addnode=node-asia.zelcash.com" >> ~/.zelcash/$CONFIG_FILE
    echo "maxconnections=256" >> ~/.zelcash/$CONFIG_FILE

sleep 2

#Setup zelcash debug.log log file rotation
echo -e "\n\033[1;33mConfiguring log rotate function...\033[0m"
sleep 1
if [ -f /etc/logrotate.d/zeldebuglog ]; then
    echo -e "\033[1;36mExisting log rotate conf found, backing up to ~/zeldebuglogrotate.old ...\033[0m"
    sudo mv /etc/logrotate.d/zeldebuglog ~/zeldebuglogrotate.old;
    sleep 2
fi
touch /home/$USERNAME/zeldebuglog
cat <<EOM > /home/$USERNAME/zeldebuglog
/home/$USERNAME/.zelcash/debug.log {
    compress
    copytruncate
    missingok
    daily
    rotate 7
}
EOM
cat /home/$USERNAME/zeldebuglog | sudo tee -a /etc/logrotate.d/zeldebuglog > /dev/null
rm /home/$USERNAME/zeldebuglog
echo -e "\n\033[1;32mLog rotate configuration complete.\n~/.zelcash/debug.log file will be backed up daily for 7 days then rotated.\033[0m"
sleep 5

#begin downloading wallet binaries
echo -e "\033[1;32mKilling and removing any old instances of $COIN_NAME."
echo -e "Installing ZelCash daemon...\033[0m"

#Closing zelcash daemon if running
sudo systemctl stop zelcash > /dev/null 2>&1 && sleep 3
sudo zelcash-cli stop > /dev/null 2>&1 && sleep 5
sudo killall $COIN_DAEMON > /dev/null 2>&1
#delete any existing zelcash form /usr/local/bin and /usr/bin
sudo rm /usr/local/bin/zelcash* > /dev/null 2>&1 && sleep 2
sudo rm /usr/bin/zelcash* > /dev/null 2>&1 && sleep 2

#Install zelcash files using APT
sudo apt-get install zelcash -y
sudo chmod 755 /usr/local/bin/zelcash*

# Download and extract the bootstrap chainstate and blocks files to ~/.zelcash
echo -e "\033[1;32mDownloading wallet bootstrap please be patient...\033[0m"
wget -U Mozilla/5.0 $WALLET_BOOTSTRAP
unzip -o $BOOTSTRAP_ZIP_FILE -d /home/$USERNAME/.zelcash
rm -rf $BOOTSTRAP_ZIP_FILE
#end download/extract bootstrap file

#Downloading chain params
echo ""
echo -e "\033[1;32mDownloading chain params...\033[0m"
wget -q $FETCHPARAMS
chmod 770 fetch-params.sh &> /dev/null
bash fetch-params.sh
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
rm fetch-params.sh
echo -e "\033[1;33mDone fetching chain params.\033[0m"

# setup zelcash daemon to run as a service 
echo -e "\033[1;32mCreating system service file...\033[0m"
sudo touch /etc/systemd/system/$COIN_NAME.service
sudo chown $USERNAME:$USERNAME /etc/systemd/system/$COIN_NAME.service
cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target
[Service]
Type=forking
User=$USERNAME
Group=$USERNAME
WorkingDirectory=/home/$USERNAME/.zelcash/
ExecStart=$COIN_PATH/$COIN_DAEMON -datadir=/home/$USERNAME/.zelcash/ -conf=/home/$USERNAME/.zelcash/$CONFIG_FILE -daemon
ExecStop=-$COIN_PATH/$COIN_CLI stop
Restart=always
RestartSec=3
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5
[Install]
WantedBy=multi-user.target
EOF
sudo chown root:root /etc/systemd/system/$COIN_NAME.service
sudo systemctl daemon-reload
sleep 3
sudo systemctl enable $COIN_NAME.service &> /dev/null

echo -e "\033[1;33mSystemctl Complete....\033[0m"

echo ""
echo -e "\033[1;33m=================================================================="
echo "DO NOT CLOSE THIS WINDOW OR TRY TO FINISH THIS PROCESS "
echo "PLEASE WAIT UNTIL YOU SEE THE RESTARTING WALLET MESSAGE"
echo -e "==================================================================\033[0m"
echo ""

echo -e "\033[1;32mConfiguring firewall and enabling fail2ban...\033[0m"
sudo ufw allow $SSHPORT/tcp
sudo ufw allow $PORT/tcp
sudo ufw logging on
sudo ufw default deny incoming
sudo ufw default allow outgoing
echo "y" | sudo ufw enable >/dev/null 2>&1
sudo systemctl enable fail2ban >/dev/null 2>&1
sudo systemctl start fail2ban >/dev/null 2>&1
echo -e "\033[1;33mBasic security completed...\033[0m"

echo -e "\033[1;32mBenchmarking node & syncing $COIN_NAME wallet with blockchain, please be patient...\033[0m"
$COIN_DAEMON -daemon &> /dev/null
countdown "00:10:00"
$COIN_CLI stop &> /dev/null
sleep 15
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
echo -e "\033[1;32mRestarting ZelNode Daemon...\033[0m"
$COIN_DAEMON -daemon &> /dev/null
for (( counter=30; counter>0; counter-- ))
do
echo -n ". "
sleep 1
done
printf "\n"

sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
echo -e "\033[1;32mFinalizing ZelNode Setup...\033[0m"
sleep 5

printf "\033[1;34m"
figlet -t -k "WELCOME   TO   ZELNODES" 
printf "\e[0m"

echo -e "\033[1;33m==================================================================="
echo -e "\033[1;32mPLEASE COMPLETE THE ZELNODE SETUP IN YOUR ZELCORE/ZELMATE WALLET\033[0m"
echo -e "COURTESY OF \033[1;34mALTTANK FAM\033[0m, \033[1;34mDK808\033[0m, \033[1;34mGOOSE-TECH\033[0m, \033[1;34mSKYSLAYER\033[0m, & \033[1;34mPACKETFLOW"
echo -e "\033[1;33m===================================================================\033[0m"
echo -e
read -n1 -r -p "Press any key to continue..." key
for (( countera=120; countera>0; countera-- ))
do
clear
echo -e "\033[1;33m==========================================================="
echo -e "\033[1;32mZELNODE SYNC STATUS"
echo -e "THIS SCREEN REFRESHES EVERY 30 SECONDS"
echo -e "TO VIEW THE CURRENT BLOCK GO TO https://explorer.zel.cash/ "
echo -e "\033[1;33m===========================================================\033[0m"
echo ""
$COIN_CLI getinfo
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
echo -e '\033[1;32mPress [CTRL-C] when correct blockheight has been reached to exit.\033[0m'
    countdown "00:00:30"
done
printf "\n"
