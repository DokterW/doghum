#!/bin/bash
# Dokter's GitHub Manager (upgrade) v0.2
# Made by Dr. Waldijk
# Upgrader for a (pseudo) packet manager for rpms hosted on GitHub and Dokter's bash scripts.
# Read the README.md for more info.
# By running this script you agree to the license terms.
# -----------------------------------------------------------------------------------
wget -q -N --show-progress https://raw.githubusercontent.com/DokterW/doghum/master/start.sh -P $HOME/.dokter/doghum/
rm $HOME/.dokter/doghum/upgrade_doghum.sh
