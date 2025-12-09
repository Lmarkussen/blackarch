#!/usr/bin/env bash

set -e

echo "[*] Updating pacman and installing requirements..."

sudo pacman --noconfirm -Syyu

sudo pacman --noconfirm --needed -S git ansible reflector base-devel


# Make sure pacman DB isn't locked
if [[ -e /var/lib/pacman/db.lck ]]; then
    sudo rm /var/lib/pacman/db.lck
fi
WORKDIR="/tmp/yay_install"

echo "[+] Creating temp directory: $WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "[+] Cloning yay from AUR..."
git clone https://aur.archlinux.org/yay.git

echo "[+] Building yay (makepkg)..."
cd yay
makepkg -si --noconfirm

echo "[+] Cleaning up..."
cd ~
rm -rf "$WORKDIR"
echo "[*] Running playbook..."
ansible-playbook blackarch_setup.yml --ask-become-pass

echo
echo "==============================================================="
echo " 🎯 Full Setup Completed — REBOOT Recommended "
echo "==============================================================="
echo
