#!/usr/bin/env bash

# Fail fast
set -e

echo "[*] Checking prerequisites..."

# Make sure pacman DB is unlocked
if [[ -e /var/lib/pacman/db.lck ]]; then
    sudo rm /var/lib/pacman/db.lck
fi

# 1) Update mirrorlist and package databases
echo "[*] Updating system..."
sudo pacman -Syyu --noconfirm

# 2) Install git + ansible if missing
echo "[*] Installing dependencies (git, ansible)..."
sudo pacman -S --noconfirm --needed git ansible

# 3) Show ansible version
echo "[*] Using ansible:"
ansible --version

# 4) Run the playbook cleanly
echo "[*] Running Ansible playbook..."
ansible-playbook blackarch_setup.yml --ask-become-pass

echo "[+] DONE! Log out & in if Docker group was created."
