#!/usr/bin/env bash

set -e

echo "[*] Updating pacman and installing requirements..."

sudo pacman --noconfirm -Syyu

sudo pacman --noconfirm --needed -S git ansible reflector base-devel


# Make sure pacman DB isn't locked
if [[ -e /var/lib/pacman/db.lck ]]; then
    sudo rm /var/lib/pacman/db.lck
fi

echo "[*] Running playbook..."
ansible-playbook blackarch_setup.yml --ask-become-pass

echo
echo "==============================================================="
echo " 🎯 Full Setup Completed — REBOOT Recommended "
echo "==============================================================="
echo
