#!/usr/bin/env bash

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

clear

echo -e "${CYAN}${BOLD}"
echo "==============================================================="
echo "              🔥 BlackArch Setup Installer 🔥"
echo "==============================================================="
echo -e "${NC}"


#===============================================================
#   Clone yay
#===============================================================
echo -e "${BLUE}[+]${NC} Cloning yay from AUR..."
git clone https://aur.archlinux.org/yay.git


#===============================================================
#   Build yay
#===============================================================
echo -e "${BLUE}[+]${NC} Building yay (makepkg)..."
cd yay
makepkg -si --noconfirm
echo -e "${GREEN}[✔] yay installation finished.${NC}"


#===============================================================
#   Install Brave, Extension Manager & Proton Pass
#===============================================================
echo -e "${BLUE}[+]${NC} Installing Brave browser, Extension-manager and ProtonPass..."
cd ~/blackarch/
yay -S extension-manager brave-bin protonpass --noconfirm
echo -e "${GREEN}[✔] extension-manager, Brave and ProtonPass installed.${NC}"


#===============================================================
#   Install GNOME Extensions
#===============================================================
echo -e "${BLUE}[+]${NC} Installing GNOME Extensions..."
gnome-extensions install blurmyshell.zip --force
gnome-extensions install dashtodock.zip --force
echo -e "${GREEN}[✔] GNOME Extensions installed.${NC}"


#===============================================================
#   Run Ansible Playbook
#===============================================================
echo -e "${YELLOW}[*] Running Ansible playbook...${NC}"
cd "$ORIG_DIR"
ansible-playbook blackarch_setup.yml --ask-become-pass


#===============================================================
#   Cleanup after success
#===============================================================
echo -e "${BLUE}[+]${NC} Cleaning up temp working directory..."
rm -rf "$WORKDIR"


#===============================================================
#   Done
#===============================================================
echo -e "${CYAN}${BOLD}"
echo "==============================================================="
echo " 🎯 Full System Setup Completed — REBOOT Recommended"
echo "==============================================================="
echo -e "${NC}"

