#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

echo "[1] - copying files"

sudo cp _rpi-wpa3.service /etc/systemd/system/

echo "[2] - setting permissions"

sudo find . -type f -exec chmod 644 {} \;
sudo find . -type d -exec chmod 755 {} \;
sudo chmod +x hostap/wpa_supplicant/* 2>/dev/null || true
sudo chmod +x *.sh

sudo systemctl daemon-reload

echo "[3] - unmanaging interface"

sudo ./interface_unmanage.sh

echo "[4] - starting service, connecting..."

sudo systemctl enable "$SERVICE"
sudo systemctl start "$SERVICE"
