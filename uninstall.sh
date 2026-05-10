#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./data/var.sh

sudo chmod +x "$BASE_DIR/uninstall.sh"
sudo "$BASE_DIR/uninstall.sh"
