#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh
S="[interface/manage]"

echo "$S[0] - unmanaging the interface..."

sudo rm -f "$NM_UNMANAGED_FILE"

echo "$S[1] - done!"
