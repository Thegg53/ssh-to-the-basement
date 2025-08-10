#!/bin/bash


# --- LOAD SECRETS ---
if [ -f "$(dirname "$0")/secrets.env" ]; then
    source "$(dirname "$0")/secrets.env"
else
    echo "[-] secrets.env file not found. Please copy secrets.env.dist to secrets.env and edit it."
    exit 1
fi


# --- CONFIGURATION ---
RDP_RESOLUTION="1920x1080"
WAIT_TIME=60

# --- SEND WOL PACKET ---
echo "[+] Sending Wake-on-LAN magic packet to $WINDOWS_MAC..."
wakeonlan "$WINDOWS_MAC"

# --- WAIT FOR MACHINE TO BE UP ---
echo "[+] Waiting up to $WAIT_TIME seconds for $WINDOWS_IP to respond..."

for (( i=1; i<=$WAIT_TIME; i++ )); do
    ping -c 1 -W 1 "$WINDOWS_IP" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "[+] Host is up after $i seconds!"
        break
    fi
    sleep 1
done

if [ $i -eq $WAIT_TIME ]; then
    echo "[-] Timed out waiting for the Windows machine to wake up."
    exit 1
fi

# --- CONNECT VIA RDP ---
echo "[+] Launching Remote Desktop session..."

# Check OS type and use appropriate RDP client
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use Microsoft Remote Desktop or create RDP file
    echo "[+] Detected macOS, creating RDP connection..."
    
    # Create a temporary RDP file
    RDP_FILE="/tmp/windows_connection.rdp"
    cat > "$RDP_FILE" << EOF
screen mode id:i:2
use multimon:i:0
desktopwidth:i:${RDP_RESOLUTION%x*}
desktopheight:i:${RDP_RESOLUTION#*x}
session bpp:i:32
winposstr:s:0,1,0,0,800,600
compression:i:1
keyboardhook:i:2
audiocapturemode:i:0
videoplaybackmode:i:1
connection type:i:7
networkautodetect:i:1
bandwidthautodetect:i:1
displayconnectionbar:i:1
username:s:${RDP_USER}
domain:s:
alternate shell:s:
shell working directory:s:
full address:s:${WINDOWS_IP}
audiomode:i:0
redirectprinters:i:1
redirectcomports:i:0
redirectsmartcards:i:1
redirectclipboard:i:1
redirectposdevices:i:0
drivestoredirect:s:
autoreconnection enabled:i:1
authentication level:i:0
prompt for credentials:i:0
negotiate security layer:i:1
remoteapplicationmode:i:0
allow font smoothing:i:0
allow desktop composition:i:0
disable wallpaper:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:0
disable cursor setting:i:0
bitmapcachepersistenable:i:1
EOF

    # Try to open with Microsoft Remote Desktop if available, otherwise use open command
    if command -v "/Applications/Microsoft Remote Desktop.app/Contents/MacOS/Microsoft Remote Desktop" &> /dev/null; then
        "/Applications/Microsoft Remote Desktop.app/Contents/MacOS/Microsoft Remote Desktop" "$RDP_FILE"
    else
        echo "[+] Opening RDP file with default application..."
        open "$RDP_FILE"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux FreeRDP syntax
    echo "[+] Detected Linux, using FreeRDP..."
    xfreerdp /u:"$RDP_USER" /p:"$RDP_PASSWORD" /v:"$WINDOWS_IP" /size:"$RDP_RESOLUTION" +clipboard +fonts /cert:ignore
else
    echo "[-] Warning: Unsupported operating system ($OSTYPE). Attempting to use standard FreeRDP syntax..."
    xfreerdp /u:"$RDP_USER" /p:"$RDP_PASSWORD" /v:"$WINDOWS_IP" /size:"$RDP_RESOLUTION" +clipboard +fonts /cert:ignore
fi
