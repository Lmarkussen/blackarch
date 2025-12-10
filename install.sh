#!/usr/bin/env bash
set -e

# Store the directory the script is launched from
ORIG_DIR="$(pwd)"

echo "[*] Updating pacman and installing requirements..."
sudo pacman --noconfirm -Syyu
sudo pacman --noconfirm --needed -S git ansible reflector base-devel

# Make sure pacman DB isn't locked
if [[ -e /var/lib/pacman/db.lck ]]; then
    echo "[!] Removing pacman lock file..."
    sudo rm /var/lib/pacman/db.lck
fi

WORKDIR="/tmp/yay_install"

echo "[+] Creating temp directory: $WORKDIR"
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "[+] Cloning yay from AUR..."
git clone https://aur.archlinux.org/yay.git

echo "[+] Building yay (makepkg)..."
cd yay
makepkg -si --noconfirm

echo "[+] yay installation finished."

echo "[+] Installing Brave browser and Extension-manager..."

yay -S extension-manager brave-bin --noconfirm
echo "[+] extension-manager and Brave installation finished."

echo "[+] Installing Extensions..."
gnome-extensions install blurmyshell.zip
gnome-extensions install dashtodock.zip

# Return to original directory to access playbook
cd "$ORIG_DIR"

echo "[*] Running Ansible playbook..."
ansible-playbook blackarch_setup.yml --ask-become-pass

echo "[+] Cleaning up temp..."
rm -rf "$WORKDIR"

echo
echo "==============================================================="
echo " 🎯 Full Setup Completed — REBOOT Recommended "
echo "==============================================================="
echo

