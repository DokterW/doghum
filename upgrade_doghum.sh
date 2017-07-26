#!/bin/bash
# Dokter's GitHub Manager (upgrade) v0.1
# Made by Dr. Waldijk
# Upgrader for the (pseudo) packet manager for Dokter's bash scripts and rpms hosted on GitHub
# Read the README.md for more info.
# By running this script you agree to the license terms.
# -----------------------------------------------------------------------------------
wget -q -N --show-progress https://raw.githubusercontent.com/DokterW/doghum/master/start.sh -P $HOME/.dokter/doghum/
rm -f $HOME/.dokter/doghum/upgrade_doghum.sh
