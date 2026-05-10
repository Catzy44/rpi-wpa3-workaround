#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

mkdir -p /etc/NetworkManager/conf.d

cat > "$NM_UNMANAGED_FILE" <<EOF
[keyfile]
unmanaged-devices=interface-name:${IFACE}
EOF
