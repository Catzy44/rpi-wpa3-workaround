#!/usr/bin/env bash

BASE_DIR="/opt/rpi_wpa3"
IFACE="wlan0"
SERVICE="_rpi-wpa3.service"

WPA_SUPP="${BASE_DIR}/hostap/wpa_supplicant/wpa_supplicant"
WPA_CLI="${BASE_DIR}/hostap/wpa_supplicant/wpa_cli"
CONF="${BASE_DIR}/connection.conf"

NM_UNMANAGED_FILE="/etc/NetworkManager/conf.d/99-unmanaged-${IFACE}.conf"
