#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh
S="[configure/opt]"

sudo nano "$BASE_DIR/connection.conf"

echo "$S[0] - restarting service/connection to apply the config..."
if systemctl is-active --quiet "$SERVICE"; then
	sudo systemctl stop "$SERVICE"
fi

sudo systemctl start "$SERVICE"
echo "$S[1] - configuration applied, services restarted!"
