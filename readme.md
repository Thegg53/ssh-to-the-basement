# SSH to the Basement

A script to wake up and connect to a remote Windows desktop via Wake-on-LAN and RDP.

## Prerequisites

This script requires Wake-on-LAN and an RDP client.

- Linux: FreeRDP (xfreerdp)
- macOS: Microsoft Remote Desktop (from the App Store)

## Installation Instructions

### Ubuntu/Linux

Dependencies: `wakeonlan` and `freerdp2-x11`

```bash
sudo apt install wakeonlan
sudo apt install freerdp2-x11
```

### macOS

Dependencies: `wakeonlan` and Microsoft Remote Desktop

Install Microsoft Remote Desktop from the App Store. Make sure you have Homebrew installed, then run:

```bash
brew install wakeonlan
```

Note: FreeRDP is not required on macOS—the script generates an .rdp file and opens it with Microsoft Remote Desktop.

## Configuration

1. Copy the secrets template file and rename it:
   ```bash
   cp secrets.env.dist secrets.env
   ```

2. Edit `secrets.env` with your Windows machine's details:
   - `WINDOWS_MAC`: Your Windows machine's MAC address
   - `WINDOWS_IP`: Your Windows machine's IP address
   - `RDP_USER`: Your Windows username
   - `RDP_PASSWORD`: Your Windows password

3. Make the script executable:
   ```bash
   chmod +x remote.sh
   ```

## Usage

Run the script:

```bash
./remote.sh
```

The script will:
1. Send a Wake-on-LAN packet to wake up your Windows machine
2. Wait for the machine to respond to ping
3. Launch an RDP connection to the desktop

