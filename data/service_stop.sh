#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

echo "[4] Czyszczę procesy dla ${IFACE}..."

sudo pkill -f "wpa_supplicant.*${IFACE}" 2>/dev/null || true
sudo pkill -f "dhcpcd.*${IFACE}" 2>/dev/null || true

sudo ip link set "$IFACE" down
sleep 1
