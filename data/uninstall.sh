#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

echo "[0] - stopping services..."
sudo systemctl stop "$SERVICE" 2>/dev/null || true
sudo systemctl disable "$SERVICE" 2>/dev/null || true

echo "[1] - restoring connection managment to NetworkInterface..."
sudo ./interface_manage.sh

echo "[2] - deleting service files..."
sudo rm -R -f "/etc/systemd/system/${SERVICE}"
sudo systemctl daemon-reload

echo "[3] - deleting main directory..."
sudo rm -R -f "$BASE_DIR"
