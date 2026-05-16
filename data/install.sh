
#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh
S="[installer/opt]"

echo "$S[1] - copying files..."

sudo cp "$SERVICE" /etc/systemd/system/

echo "$S[2] - setting permissions..."

sudo find . -type f -exec chmod 644 {} \;
sudo find . -type d -exec chmod 755 {} \;
sudo chmod +x hostap/wpa_supplicant/* 2>/dev/null || true
sudo chmod +x *.sh

echo "$S[3] - reloaging da daemon..."

sudo systemctl daemon-reload

echo "$S[4] - unmanaging $IFACE  interface.."

sudo ./interface_unmanage.sh

echo "$S[5] - starting service, connecting..."

sudo systemctl enable "$SERVICE"
sudo systemctl start "$SERVICE"

echo ""
echo "[@] Did it work?"
echo "    Please star the repo, let's make some noise,"
echo "    for the RPI devs to fix this in the os xD"
echo ""
