#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./data/var.sh

sudo chmod +x "$BASE_DIR/configure.sh"
sudo "$BASE_DIR/configure.sh"
