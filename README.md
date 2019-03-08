# ZelNodeInstallv3
ZelNode Installation Script V3

ZelNode Setup v3
zelnodev2.sh - A bash script to assist in setup/creation of ZelCash Node

NOTE: This script is the latest version for MainNet ZelNodes.
NOTE: This installation guide is provided as is with no warranties of any kind.

NOTE: This version of the script (v2.3) automatically detects your IP address, but also allows you to enter one manually.

If you follow the steps and use a newly installed Ubuntu Server 18.04 VPS, it will assist in configuring and start your Node.

Requirements
ZEL Collateral (10K Basic / 25K Super / 100K BAMF)
VPS running Linux Ubuntu 18.04 (benchmark requirements can't be guaranteed for servers that the team hasn't tested)
Controller wallet (ZelCore or ZelCash Swing Wallet)
SSH client such as Puttyor MobaXterm
Steps
Create a new VPS or use existing one.
VPS resource configuration is as follows: You can use Vultr: https://goo.gl/86MVfW or Digital Ocean: https://m.do.co/c/c9c22684c5db (link to $100 referral credit for new users)

For Basic, you can use Vultr $20/mo (60GB SSD/2xCPU/4GB RAM) or DO $20/mo (80GB SSD/2xCPU/4GB RAM)

For Super, you can use Vultr $80/mo (200GB SSD/6xCPU/8GB RAM) or DO $40/mo (160GB SSD/4xCPU/8GB RAM)

For BAMF, you can use DO $160/mo (640GB SSD/8xCPU/32GB RAM)

Connect to your VPS server console using PuTTY terminal program, login as root and create new su user:
adduser <YOURUSERNAME>
usermod -aG sudo <YOURUSERNAME>
reboot -n
Follow instructions to Create ZelNode Key using ZelCore Wallet
https://github.com/zelcash/zelcash/wiki/ZelNode-Control-Wallet-Guide-%7C-ZelCore

Launch Full Node Wallet & go to Tools | Open ZelNode Management | Create ZelNode Key

Click ZelNode Key to copy to clipboard

Download script & begin installation of ZelNode
PLEASE BE SURE YOU ARE LOGGED IN AS YOUR USERNAME BEFORE RUNNING THIS SCRIPT

wget -O zelnode.sh https://raw.githubusercontent.com/zelcash/ZelNodeInstallv2/master/zelnodev2.sh && chmod u+x zelnode.sh && sudo bash ./zelnode.sh
Follow instructions to run the install script which will install and configure your node with all necessary options. Be ready to paste your ZelNode Key when asked.

NOTE: This process may take anywhere from 5 to 15 minutes, depending on your VPS HW specs.

Once the script completes, it will output the wallet info, which shows the sync status. Make sure blocks is > 0.

Troubleshooting
plu.sh - A bash script to update ownership of blockchain files to ensure proper function of the ZelCash daemon

NOTE: Nodes that were installed with an earlier version of this script must run the Pre-Launch Update.

To run Pre-Launch Update:

Login to your ZelNode VPS with the username used to create the node
Run the following command
sudo wget -O plu.sh https://raw.githubusercontent.com/zelcash/ZelNodeInstallv2/master/plu.sh && sudo chmod +x plu.sh && bash ./plu.sh
Reboot your VPS
sudo reboot -n
Log back into your ZelNode VPS and verify Node is running
sudo zelcash-cli getinfo
A special thank you to AltTank fam, dk808, Skyslayer, & Packetflow for their contributions to this scrypt, and the ZelCash Team for debugging and assistance.
