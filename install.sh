#!/usr/bin/env bash
set -e

echo "[*] Updating Pacman keyring & system..."
sudo pacman -Sy --needed --noconfirm archlinux-keyring
sudo pacman -Syu --noconfirm

echo ""
echo "[*] Checking for git..."
if ! command -v git >/dev/null 2>&1; then
    echo "[+] Installing git..."
    sudo pacman -S --needed --noconfirm git
else
    echo "[=] git already installed."
fi

echo ""
echo "[*] Checking for ansible..."
if ! command -v ansible >/dev/null 2>&1; then
    echo "[+] Installing ansible..."
    sudo pacman -S --needed --noconfirm ansible
else
    echo "[=] ansible already installed."
fi

echo ""
echo "[*] Checking for reflector..."
if ! command -v reflector >/dev/null 2>&1; then
    echo "[+] Installing reflector..."
    sudo pacman -S --needed --noconfirm reflector
else
    echo "[=] reflector already installed."
fi

echo ""
echo "[*] Running Ansible Playbook..."
ansible-playbook blackarch_setup.yml --ask-become-pass

echo ""
echo "-----------------------------------------------------"
echo "[+] System setup COMPLETE!"
echo "You may need to relog for docker permissions."
echo "-----------------------------------------------------"
