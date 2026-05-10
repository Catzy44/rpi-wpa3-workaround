#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

echo "[1] - copying files"

sudo cp "$SERVICE" /etc/systemd/system/

echo "[2] - setting permissions"

sudo find . -type f -exec chmod 644 {} \;
sudo find . -type d -exec chmod 755 {} \;
sudo chmod +x hostap/wpa_supplicant/* 2>/dev/null || true
sudo chmod +x *.sh

echo "[3] - reloaging da daemon..."

sudo systemctl daemon-reload

echo "[4] - unmanaging interface"

sudo ./interface_unmanage.sh

echo "[5] - starting service, connecting..."

sudo systemctl enable "$SERVICE"
sudo systemctl start "$SERVICE"
