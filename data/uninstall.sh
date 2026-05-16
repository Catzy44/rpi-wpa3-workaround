#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh
S="[installer/opt]"

echo "$S[0] - stopping services..."
sudo systemctl stop "$SERVICE" 2>/dev/null || true
sudo systemctl disable "$SERVICE" 2>/dev/null || true

echo "$S[1] - restoring connection managment to NetworkInterface..."
sudo ./interface_manage.sh

echo "$S[2] - deleting service files..."
sudo rm -R -f "/etc/systemd/system/${SERVICE}"
sudo systemctl daemon-reload

echo "$S[3] - deleting main directory..."
sudo rm -R -f "$BASE_DIR"

echo "$S[4] - done!"
