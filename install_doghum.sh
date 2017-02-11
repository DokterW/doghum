#!/bin/bash
# Dokter's GitHub Manager v0.1
# Made by Dr. Waldijk
# Installer for the (pseudo) packet manager for Dokter's bash scripts and rpms hosted on GitHub
# Read the README.md for more info.
# By running this script you agree to the license terms.
# -----------------------------------------------------------------------------------
wget -q -N --show-progress https://raw.githubusercontent.com/DokterW/doghum/master/doghum/start.sh -P $HOME/.dokter/.doghum/start.sh
if [ ! -x $HOME/.dokter/.doghum/start.sh ]; then
    chmod +x $HOME/.dokter/.doghum/start.sh
fi
echo "alias doghum='$HOME/.dokter/doghum/start.sh'" >> $HOME/.bashrc
alias doghum='$HOME/.dokter/doghum/start.sh'
