#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

echo "[1] Sprawdzam pliki..."

if [ ! -x "$WPA_SUPP" ]; then
  echo "ERROR: brak wykonywalnego wpa_supplicant: $WPA_SUPP"
  exit 1
fi

if [ ! -x "$WPA_CLI" ]; then
  echo "ERROR: brak wykonywalnego wpa_cli: $WPA_CLI"
  exit 1
fi

if [ ! -f "$CONF" ]; then
  echo "ERROR: brak configu: $CONF"
  exit 1
fi

echo "[2] Wywalam ${IFACE} z NetworkManagera..."

if ! grep -Rqs "unmanaged-devices=.*interface-name:${IFACE}" /etc/NetworkManager/conf.d /usr/lib/NetworkManager/conf.d 2>/dev/null; then
  sudo mkdir -p /etc/NetworkManager/conf.d
  sudo tee "$NM_UNMANAGED_FILE" >/dev/null <<EOF
[keyfile]
unmanaged-devices=interface-name:${IFACE}
EOF
else
  echo "${IFACE} już jest unmanaged w NetworkManager."
fi

sudo systemctl restart NetworkManager

echo "[3] Status NetworkManager:"
nmcli dev status | grep -E "^(DEVICE|${IFACE})" || true

echo "[4] Czyszczę stare procesy dla ${IFACE}..."

sudo pkill -f "wpa_supplicant.*${IFACE}" 2>/dev/null || true
sudo pkill -f "dhcpcd.*${IFACE}" 2>/dev/null || true

sudo ip link set "$IFACE" down
sleep 1
sudo ip link set "$IFACE" up
sleep 1

echo "[5] Startuję ręcznie wpa_supplicant 2.11..."

sudo "$WPA_SUPP" -B -i "$IFACE" -c "$CONF" -D nl80211

echo "[6] Czekam na WPA3/SAE..."

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
  echo "ERROR: WPA3/SAE nie połączyło się."
  sudo "$WPA_CLI" -i "$IFACE" status || true
  exit 1
fi

echo "[7] Pobieram IP przez dhcpcd..."

sudo dhcpcd -n "$IFACE" || sudo dhcpcd "$IFACE"

echo "[8] Wynik:"
ip addr show "$IFACE"
ip route

echo "OK: ${IFACE} działa przez ręczny wpa_supplicant."
