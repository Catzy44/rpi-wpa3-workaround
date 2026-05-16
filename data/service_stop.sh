
#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

echo "[service/stop][0] killing old processes for ${IFACE}..."

sudo pkill -f "wpa_supplicant.*${IFACE}" 2>/dev/null || true
sudo pkill -f "dhcpcd.*${IFACE}" 2>/dev/null || true

sudo ip link set "$IFACE" down
sleep 1

echo "[service/stop][0] done!"
