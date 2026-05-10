#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

sudo nano "$BASE_DIR/connection.conf"

echo "[0] - restarting service/connection to apply the config..."
if systemctl is-active --quiet "$SERVICE"; then
	sudo systemctl stop "$SERVICE"
fi

sudo systemctl start "$SERVICE"
echo "[1] - configuration applied!"
