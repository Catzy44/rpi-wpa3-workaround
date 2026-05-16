#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh
S="[interface/unmanage]"

echo "$S[0] - making sure NM/conf.d is created..."
mkdir -p /etc/NetworkManager/conf.d

echo "$S[1] - unmanaging the interface..."
cat > "$NM_UNMANAGED_FILE" <<EOF
[keyfile]
unmanaged-devices=interface-name:${IFACE}
EOF

echo "$S[2] - done!"
