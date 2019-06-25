# ZelNode Setup v3.0
zelnode.sh - A bash script to assist in setup/creation of ZelCash Node

## NOTE: This script is the latest version for MainNet ZelNodes.

**NOTE:** This script is the latest version for MainNet ZelNodes.

**NOTE:** This installation guide is provided as is with no warranties of any kind.

**NOTE:** This version of the script (v3.0) automatically detects your IP address, but also allows you to enter one manually.

**NOTE:** Advanced users are given the option to configure a custom SSH port.

If you follow the steps and use a newly installed Ubuntu Server 18.04 VPS, it will assist in configuring and start your Node.

***
## Requirements
1) **ZEL Collateral (10K Basic / 25K Super / 100K BAMF)**
2) **VPS running Linux Ubuntu 18.04** (benchmark requirements can't be guaranteed for servers that the team hasn't tested)
3) **Controller wallet (ZelCore or ZelCash Swing Wallet)**
4) **SSH client such as [Putty](https://www.putty.org/)or [MobaXterm](https://mobaxterm.mobatek.net/)**

***
## Steps

1) **Create a new VPS** or use existing one.

VPS resource configuration is as follows:
You can use Vultr: https://www.vultr.com/register/
or Digital Ocean: https://m.do.co/c/c9c22684c5db (link to $100 referral credit for new users)

   **For Basic, you can use Vultr $20/mo (60GB SSD/2xCPU/4GB RAM) or DO $20/mo (80GB SSD/2xCPU/4GB RAM)**

   **For Super, you can use Vultr $40/mo (160GB SSD/4xCPU/8GB RAM) or DO  $40/mo (160GB SSD/4xCPU/8GB RAM)**

   **For BAMF, you can use Vultr $160/mo (640GB SSD/8xCPU/32GB RAM) or DO $160/mo (640GB SSD/8xCPU/32GB RAM)**

2) **Connect to your VPS server console using PuTTY** terminal program, login as root and create new su user:

```
adduser <YOURUSERNAME>
usermod -aG sudo <YOURUSERNAME>
reboot -n
```

3) **Follow instructions to Create ZelNode Key using ZelCore Wallet**

https://github.com/zelcash/zelcash/wiki/ZelNode-Control-Wallet-Guide-%7C-ZelCore

Launch Full Node Wallet & go to **Tools | Open ZelNode Management | Create ZelNode Key**

Click ZelNode Key to copy to clipboard

4) **Download script & begin installation of ZelNode**

**PLEASE BE SURE YOU ARE LOGGED IN AS YOUR USERNAME BEFORE RUNNING THIS SCRIPT**

```
wget -O zelnode.sh https://raw.githubusercontent.com/dk808/ZelNodeInstallv3/master/zelnodev3.sh && chmod +x zelnode.sh && ./zelnode.sh
```

**Follow instructions to run the install script** which will install and configure your node with all necessary options.
Be ready to paste your ZelNode Key when asked.

***
__NOTE:__ This process may take anywhere from 5 to 15 minutes, depending on your VPS HW specs.

Once the script completes, it will output the wallet info, which shows the sync status. Make sure blocks is > 0.
***
Many thanks to **AltTank fam**, **dk808**, **Skyslayer**, **Goose-Tech**, & **Packetflow** for their contributions to this scrypt, and the **ZelCash Team** for debugging and assistance.
