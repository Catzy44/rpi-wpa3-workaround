#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

echo "[0] kicking ${IFACE} out of the NetworkManager..."

if ! grep -Rqs "unmanaged-devices=.*interface-name:${IFACE}" /etc/NetworkManager/conf.d /usr/lib/NetworkManager/conf.d 2>/dev/null; then
  sudo mkdir -p /etc/NetworkManager/conf.d
  sudo tee "$NM_UNMANAGED_FILE" >/dev/null <<EOF
[keyfile]
unmanaged-devices=interface-name:${IFACE}
EOF
else
  echo "${IFACE} is already out of NetworkManager."
fi

sudo systemctl restart NetworkManager

echo "[1] NetworkManager's status:"
nmcli dev status | grep -E "^(DEVICE|${IFACE})" || true

echo "[1] killing old processes for dla ${IFACE}..."

sudo pkill -f "wpa_supplicant.*${IFACE}" 2>/dev/null || true
sudo pkill -f "dhcpcd.*${IFACE}" 2>/dev/null || true

sudo ip link set "$IFACE" down
sleep 1
sudo ip link set "$IFACE" up
sleep 1

echo "[2] starting wpa_supplicant 2.11..."

sudo "$WPA_SUPP" -B -i "$IFACE" -c "$CONF" -D nl80211

echo "[3] waiting for WPA3/SAE..."

connected=0

for i in $(seq 1 30); do
  if sudo "$WPA_CLI" -i "$IFACE" status 2>/dev/null | grep -q "wpa_state=COMPLETED"; then
    echo "CONNECTED"
    connected=1
    break
  fi

  state="$(sudo "$WPA_CLI" -i "$IFACE" status 2>/dev/null | grep "wpa_state=" || true)"
  echo "wait ${i}/30 ${state}"
  sleep 1
done

if [ "$connected" -ne 1 ]; then
  echo "[!]  error: WPA3/SAE did not connect!."
  sudo "$WPA_CLI" -i "$IFACE" status || true
  exit 1
fi

echo "[4] getting an IP..."

sudo dhcpcd -n "$IFACE" || sudo dhcpcd "$IFACE"

echo "[5] Wynik:"
ip addr show "$IFACE"
ip route

echo "[+]  status: ${IFACE} is up!."
