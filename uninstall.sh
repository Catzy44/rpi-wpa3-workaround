#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./data/var.sh
S="[uninstaller]"

echo "$S[0] - uninstalling..."

sudo chmod +x "$BASE_DIR/uninstall.sh"
sudo "$BASE_DIR/uninstall.sh"

echo "$S[1] - done!"
