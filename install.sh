#!/usr/bin/env bash
set -Eeuo pipefail

#===============================================================
#   Visual Formatting
#===============================================================
NC="\e[0m"
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RESOURCES_ZIP="$SCRIPT_DIR/resources.zip"
WORKDIR="$(mktemp -d)"

cleanup() {
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

die() {
    echo -e "${RED}[x]${NC} $*" >&2
    exit 1
}

[[ "$EUID" -ne 0 ]] || die "Run this installer as your normal user, not with sudo."

clear

echo -e "${CYAN}${BOLD}"
echo "==============================================================="
echo "              🔥 BlackArch Setup Installer 🔥"
echo "==============================================================="
echo -e "${NC}"

#===============================================================
#   Decompressing Resources
#===============================================================
echo -e "${BLUE}[+]${NC} Decompressing..."
[[ -f "$RESOURCES_ZIP" ]] || die "Missing resources.zip next to install.sh"
unzip -q "$RESOURCES_ZIP" -d "$WORKDIR"

#===============================================================
#   Install Build Prerequisites
#===============================================================
echo -e "${BLUE}[+]${NC} Installing build prerequisites..."
sudo pacman -Syu --needed base-devel fakeroot debugedit git go --noconfirm
echo -e "${GREEN}[✔] Build prerequisites installed.${NC}"

#===============================================================
#   Clone yay
#===============================================================
echo -e "${BLUE}[+]${NC} Cloning yay from AUR..."
git clone https://aur.archlinux.org/yay.git "$WORKDIR/yay"


#===============================================================
#   Build yay
#===============================================================
echo -e "${BLUE}[+]${NC} Building yay (makepkg)..."
cd "$WORKDIR/yay"
makepkg -si --noconfirm
echo -e "${GREEN}[✔] yay installation finished.${NC}"


#===============================================================
#   Install Brave, Extension Manager & Proton Pass
#===============================================================
echo -e "${BLUE}[+]${NC} Installing Brave browser, Extension-manager and ProtonPass..."
yay -S extension-manager brave-bin protonpass --noconfirm
echo -e "${GREEN}[✔] extension-manager, Brave and ProtonPass installed.${NC}"


#===============================================================
#   Install GNOME Extensions
#===============================================================
echo -e "${BLUE}[+]${NC} Installing GNOME Extensions..."
gnome-extensions install "$WORKDIR/blurmyshell.zip" --force
echo -e "${GREEN}[✔] GNOME Extensions installed.${NC}"


#===============================================================
#   Install Ansible
#===============================================================
echo -e "${BLUE}[+]${NC} Installing Ansible..."
sudo pacman -Syu --needed ansible --noconfirm
echo -e "${GREEN}[✔] Ansible installation finished.${NC}"


#===============================================================
#   Run Ansible Playbook
#===============================================================
echo -e "${YELLOW}[*] Running Ansible playbook...${NC}"
ANSIBLE_CONFIG="$WORKDIR/ansible.cfg" ansible-playbook "$WORKDIR/blackarch_setup.yml" --ask-become-pass


#===============================================================
#   Cleanup after success
#===============================================================
echo -e "${BLUE}[+]${NC} Cleaning up temp working directory..."


#===============================================================
#   Done
#===============================================================
echo -e "${CYAN}${BOLD}"
echo "==============================================================="
echo " 🎯 Full System Setup Completed — REBOOT Recommended"
echo "==============================================================="
echo -e "${NC}"
