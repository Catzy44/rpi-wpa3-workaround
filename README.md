# Raspberry Pi WPA3 workaround / fix

Hewo!

Let me present to You my small WPA3 workaround for Raspberry Pi and other stubborn little boxes.

This project takes control of `wlan0` `away from NetworkManager` and lets a `dedicated scripted wpa_supplicant v2.11` service handle the connection directly. This `included version is from DEV enviorment (v2.11` instead o v2.10) and it's `capable of handling this WPA3`

Useful when Raspberry Pi keeps failing on WPA3/SAE networks, loops on password prompts, or refuses to stay connected even though the password is correct.

## Tiny safety note

This thing takes control of `wlan0` away from NetworkManager.

If you run it over SSH through the same Wi-Fi you are trying to fix, and the config is wrong, the little box may politely disappear from the network.

Physical access is recommended.
## TLDR

```bash
git clone https://github.com/Catzy44/rpi-wpa3-workaround.git
cd rpi-wpa3-workaround
chmod +x install.sh configure.sh uninstall.sh
sudo ./install.sh
```

## What it does

- installs files into `/opt/rpi_wpa3`
- installs a systemd service
- keeps Wi-Fi connection config in one file
- tells NetworkManager to leave wlan0 alone
- runs its own wpa_supplicant for WPA3/SAE
- gives you simple install, configure and uninstall scripts

## Files

```text
install.sh       install the workaround
configure.sh     edit connection config and restart service
uninstall.sh     remove the workaround
data/            service file and helper scripts
```

## Details

Yeah so I had a headache because I really wanted to implement WPA3 into my network and even the shi... Worst microcontrollers like ESP32 connected seamlessly to it my RPI5 did not!
Why?... Because... RPI is using outdated wpa_supplicant (v2.10) and for the needs of the mightyy WPA3 u need v2.11... Which is not working with included NetworkManager...
So... I have built this package. Thich contains already-compiled binaries od 2.11 wpa_supplicant for ARM64 and some scrips which bypass included NetworkManager entiriely.
It is not gonna replace your v2.10 wpa_supplicant. It's gonna use v2.11 launched totally separatelly just for the sake of one wlan card of ur choosing.
It's gonna install a service into your system. A service which is controlling this 2.11 wpa_supplicant directly and getting it to connect to WPA3 network of your choosing.
And thats it! Mrwah!

## Tested on

- Raspberry Pi 5
- Raspberry Pi OS 64-bit
- `wlan0`
- NetworkManager
- WPA3/SAE network (Orange FunBox)
- bundled `wpa_supplicant` v2.11 built for ARM64
