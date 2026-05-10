#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./data/var.sh

INSTALLER_DIR="$(pwd)"

### 1 - intro
echo "[@] WPA3 workaround for Raspberry Pi... and other stubborn little critters."
echo "    It takes wlan0 away from NetworkManager,"
echo "    puts the Wi-Fi link on a short leash,"
echo "    and manages the connection internally."
echo "    Run with physical access, you fluffy little gremlin."
echo ""

### 2 - check for architecture - binaries are compiled for ARM64 and I'm too lazy to recompile for AMR32 too...
ARCH="$(uname -m)"
if [[ "$ARCH" != "aarch64" && "$ARCH" != "arm64" ]]; then
    echo "[!] error: unsupported architecture: $ARCH"
    echo "    This package contains ARM64/aarch64 wpa_supplicant binaries only"
    echo "    Please recompile attached binaries and remove this check!"
    echo "    (A PR with ARM32 binaries would be welcome ;p)"
    exit 1
fi

### 3 - check if already installed
if [ -d "$BASE_DIR" ]; then
  echo "[!] error: Already installed!"
  echo "    Uninstall first: ./uninstall.sh"
  echo "    In case of trouble please delete /opt/rpi_wpa3 directory"
  echo ""
  exit 0
fi

### 4 - ask for interface name
read -p "[?] - Is your interface wlan0? [Y/n] (it should be)" ANSWER
if [[ "$ANSWER" == "n" || "$ANSWER" == "N" ]]; then
    sudo nano "./data/var.sh"
fi

### 5 - check for dhcpcd, because we kind usin it ;p
command -v dhcpcd >/dev/null || { echo "[!] error: dhcpcd not installed!"; exit 1; }

### 6 - configure the connection before da files're copied
INSTALLER_CONNECTION_CONF_FILE="$INSTALLER_DIR/data/connection.conf"
read -p "[?] - Do you want to configure the connection now? [y/N]" ANSWER
if [[ "$ANSWER" == "y" || "$ANSWER" == "Y" ]]; then
    sudo nano "$INSTALLER_CONNECTION_CONF_FILE"
fi

### 7 - we're set, lets go!
echo "[0] - running the real installation script..."

sudo mkdir -p "$BASE_DIR"
sudo cp -r data/* "$BASE_DIR"

sudo chmod +x "$BASE_DIR/install.sh"
sudo "$BASE_DIR/install.sh"
