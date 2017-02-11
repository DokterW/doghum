#!/bin/bash
# Dokter's GitHub Manager v0.2
# Made by Dr. Waldijk
# Installer for the (pseudo) packet manager for Dokter's bash scripts and rpms hosted on GitHub
# Read the README.md for more info.
# By running this script you agree to the license terms.
# -----------------------------------------------------------------------------------
if [ ! -d $HOME/.dokter ]; then
    mkdir $HOME/.dokter
fi
if [ ! -d $HOME/.dokter/doghum ]; then
    mkdir $HOME/.dokter/dogum
fi
wget -q -N --show-progress https://raw.githubusercontent.com/DokterW/doghum/master/start.sh -P $HOME/.dokter/doghum/
if [ ! -x $HOME/.dokter/doghum/start.sh ]; then
    chmod +x $HOME/.dokter/doghum/start.sh
fi
echo "alias doghum='$HOME/.dokter/doghum/start.sh'" >> $HOME/.bashrc
alias doghum='$HOME/.dokter/doghum/start.sh'
