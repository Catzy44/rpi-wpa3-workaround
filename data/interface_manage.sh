#!/bin/bash
set -e
cd "$(dirname "$0")"
source ./var.sh

rm -f "$NM_UNMANAGED_FILE"
