# SSH to the Basement

A script to wake up and connect to a remote Windows desktop via Wake-on-LAN and RDP.

## Prerequisites

This script requires Wake-on-LAN and FreeRDP tools to be installed on your system.

## Installation Instructions

### Ubuntu/Linux

Dependencies: `wakeonlan` and `freerdp2-x11`

```bash
sudo apt install wakeonlan
sudo apt install freerdp2-x11
```

### macOS

Dependencies: `wakeonlan` and `freerdp`

Make sure you have Homebrew installed, then run:

```bash
brew install wakeonlan
brew install freerdp
```

## Usage

1. Configure the variables at the top of `remote.sh` with your Windows machine's details
2. Make the script executable: `chmod +x remote.sh`
3. Run the script: `./remote.sh`

The script will:
1. Send a Wake-on-LAN packet to wake up your Windows machine
2. Wait for the machine to respond to ping
3. Launch an RDP connection to the desktoptu dependencies are “wakeonlan” and “freerdp2-x11”

sudo apt install wakeonlan
sudo apt install freerdp2-x11