#!/bin/bash
# Dokter's GitHub Manager v0.1
# Made by Dr. Waldijk
# A (pseudo) packet manager for Dokter's bash scripts and rpms hosted on GitHub
# Read the README.md for more info.
# By running this script you agree to the license terms.
# Standard --------------------------------------------------------------------------
DOGHUMVER="0.1"
DOGHUMNAM="Dokter's GitHub Manager"
DOGHUMDES="A (pseudo) packet manager for Dokter's bash scripts and rpms hosted on GitHub."
# Settings --------------------------------------------------------------------------
DOGHUMCOM=$1
DOGHUMARG=$2
DOGHUMBSH=$(curl -s --connect-timeout 10 https://raw.githubusercontent.com/DokterW/doghum/master/doghumbsh)
DOGHUMRPM=$(curl -s --connect-timeout 10 https://raw.githubusercontent.com/DokterW/doghum/master/doghumrpm)
# DOGHUMRDM=$(curl -s --connect-timeout 10 https://raw.githubusercontent.com/DokterW/doghum/master/doghumman)
DOGHUMRPN=".x86_64.rpm"
DOGHUMBSN="start.sh"
# Functions -------------------------------------------------------------------------
doghumchk () {
    # Check if it's a bash script or a rpm.
    DOGHUMCHK1=$(echo "$DOGHUMBSH" | cut -d , -f 1 | grep $DOGHUMARG | tr '[:upper:]' '[:lower:]')
    DOGHUMCHK2=$(echo "$DOGHUMRPM" | cut -d , -f 1 | grep $DOGHUMARG | tr '[:upper:]' '[:lower:]')
}
doghumurlverfetch () {
    if [ -n $DOGHUMCHK1 ]; then
        # Regex out the version.
        DOGHUMLTS=$(curl -ILs -o /dev/null -w %{url_effective} https://github.com/DokterW/$DOGHUMARG/releases/latest | egrep -o '([0-9]{1,2}\.)*[0-9]{1,2}')
    elif [ -n $DOGHUMCHK2 ]; then
        # Fetch latest version URL.
        DOGHUMURL=$(curl -ILs -o /dev/null -w %{url_effective} https://github.com/$DOGHUMARG/$DOGHUMARG/releases/latest)
        # Same as above, but regex out the version.
        DOGHUMLTS=$(curl -ILs -o /dev/null -w %{url_effective} https://github.com/$DOGHUMARG/$DOGHUMARG/releases/latest | egrep -o '([0-9]{1,2}\.)*[0-9]{1,2}')
    fi
}
doghumbashdl () {
    # Download bash script and make it an executable if it's not.
    wget -q -N --show-progress https://raw.githubusercontent.com/DokterW/$DOGHUMARG/master/$DOGHUMBSN -P $HOME/.dokter/$DOGHUMARG/$DOGHUMBSN
    if [ ! -x $HOME/.dokter/$DOGHUMARG/$DOGHUMBSN ]; then
        chmod +x $HOME/.dokter/$DOGHUMARG/$DOGHUMBSN
    fi
}
# -----------------------------------------------------------------------------------
if [ "$DOGHUMCOM" = install ] && [ -z "$DOGHUMARG" ]; then
    echo "I can't read your mind. Tell me what you want to install."
    echo "Type 'dogum list' to get a list of available scripts and software."
elif [ "$DOGHUMCOM" = install ] && [ -n "$DOGHUMARG" ]; then
    doghumchk
    if [ -n $DOGHUMCHK1 ]; then
        if [ ! -e $HOME/.dokter/$DOGHUMARG/$DOGHUMBSN ]; then
            if [ ! -d $HOME/.dokter ]; then
                mkdir $HOME/.dokter
            fi
            mkdir $HOME/.dokter/$DOGHUMARG
            doghumbashdl
            echo "alias $DOGHUMARG='$HOME/.dokter/$DOGHUMARG/$DOGHUMBSN'" >> $HOME/.bashrc
            # Adding alias so user don't need to restart terminal.
            alias $DOGHUMARG='$HOME/.dokter/$DOGHUMARG/$DOGHUMBSN'
        else
            echo "You cannot install a bash script that is already installed."
        fi
    elif [ -n $DOGHUMCHK2 ]; then
        if [ ! -e /bin/$DOGHUMARG ]; then
            doghumurlverfetch
            DOGHUMDLD="https://github.com/$DOGHUMARG/$DOGHUMARG/releases/download/v"
            wget -q --show-progress $DOGHUMDLD$DOGHUMLTS/$DOGHUMARG$DOGHUMRPN -P /tmp/
            sudo dnf -y install /tmp/$DOGHUMARG$DOGHUMRPN
            rm /tmp/$DOGHUMARG$DOGHUMRPN
        else
            echo "You cannot install software that is already installed."
        fi
    fi
elif [ "$DOGHUMCOM" = upgrade ] && [ -z "$DOGHUMARG" ]; then
    echo "I can't read your mind. Tell me what you want to upgrade."
    echo "Type 'dogum list' to get a list of available scripts and software."
elif [ "$DOGHUMCOM" = upgrade ] && [ -n "$DOGHUMARG" ]; then
    doghumchk
    if [ -n $DOGHUMCHK1 ]; then
        if [ -e $HOME/.dokter/$DOGHUMARG/$DOGHUMBSN ]; then
            doghumurlverfetch
            DOGHUMIND=$(cat $HOME/.dokter/$DOGHUMARG/$DOGHUMBSN | sed -n "2p" | egrep -o '([0-9]{1,2}\.)*[0-9]{1,2}')
            if [ "$DOGHUMLTS" != "$DOGHUMIND" ]; then
                doghumbashdl
            else
                echo "You already have the latest version of $DOGHUMARG v$DOGHUMLTS installed."
            fi
        fi
    elif [ -n $DOGHUMCHK2 ]; then
        if [ -e /bin/$DOGHUMARG ]; then
            doghumurlverfetch
            # Fetch version of installed software.
            DOGHUMIND=$(dnf info $DOGHUMARG --cacheonly | grep Version | egrep -o '([0-9]{1,2}\.)*[0-9]{1,2}')
            if [ "$DOGHUMLTS" != "$DOGHUMIND" ]; then
                # Download, upgrade & remove d/l file
                wget -q --show-progress $DOGHUMDLD$DOGHUMLTS/$DOGHUMARG$DOGHUMRPN -P /tmp/
                sudo dnf -y upgrade /tmp/$DOGHUMARG$DOGHUMRPN
                rm /tmp/$DOGHUMARG$DOGHUMRPN
            else
                echo "You already have the latest version of $DOGHUMARG v$DOGHUMLTS installed."
            fi
        else
            echo "You cannot update software that is not installed."
        fi
    fi
elif [ "$DOGHUMCOM" = remove ] && [ -z "$DOGHUMARG" ]; then
    echo "I can't read your mind. Tell me what you want to remove."
    echo "Type 'dogum list' to get a list of available scripts and software."
elif [ "$DOGHUMCOM" = remove ] && [ -n "$DOGHUMARG" ]; then
    doghumchk
    if [ -n $DOGHUMCHK1 ]; then
        if [ -e $HOME/.dokter/$DOGHUMARG/$DOGHUMBSN ]; then
            # Using the -i option for safety as rm -r will and can mess up stuff.
            # I will still try to find a better, safer solution for this removal.
            # Might move the folder to /tmp before deletion.
            rm -ri $HOME/.dokter/$DOGHUMARG
            sed -i -e "/alias $DOGHUMARG='$HOME\/\.dokter\/$DOGHUMARG\/start\.sh'/d" $HOME/.bashrc
        else
            echo "You cannot remove a bash script that is not installed."
        fi
    elif [ -n $DOGHUMCHK2 ]; then
        if [ -e /bin/$DOGHUMARG ]; then
            sudo dnf -y remove $DOGHUMARG
        else
            echo "You cannot remove software that is not installed."
        fi
    fi
elif [ "$DOGHUMCOM" = list ]; then
    # Adding loop later to list both name and description.
#    DOGHUMDL1=$(echo "$DOGHUMBSH" | cut -d , -f 1)
#    DOGHUMDL2=$(echo "$DOGHUMBSH" | cut -d , -f 2)
    echo $DOGHUMNAM - v$DOGHUMVER
    echo ""
    echo "$DOGHUMRPM" | cut -d , -f 1
    echo "$DOGHUMBSH" | cut -d , -f 1
elif [ "$DOGHUMCOM" = version ]; then
    echo $DOGHUMNAM - v$DOGHUMVER
elif [ -n "$DOGHUMCOM" ] && [ -z "$DOGHUMARG" ]; then
    echo "$DOGHUMCOM is invalid."
elif [ -n "$DOGHUMCOM" ] && [ -n "$DOGHUMARG" ]; then
    echo "$DOGHUMCOM & $DOGHUMARG are invalid."
else
    echo $DOGHUMNAM - v$DOGHUMVER
    echo $DOGHUMDES
    echo ""
    echo "doghum <command> [<arg>]"
    echo ""
    echo "Available commands"
    echo ""
    echo "install"
    echo "upgrade"
    echo "remove"
    echo "list"
fi
# Clearing variables just in case and for tidyness.
DOGHUMVER=""
DOGHUMNAM=""
DOGHUMDES=""
DOGHUMCOM=""
DOGHUMARG=""
DOGHUMBSH=""
DOGHUMRPM=""
DOGHUMRDM=""
DOGHUMRPN=""
DOGHUMBSN=""
DOGHUMCHK1=""
DOGHUMCHK2=""
DOGHUMURL=""
DOGHUMLTS=""
DOGHUMLST=""
DOGHUMDLD=""
DOGHUMIND=""
#DOGHUMDL1=""
#DOGHUMDL2=""
