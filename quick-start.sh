# -----------------------------------------------
# Quick start simpler one script installer
#   This script will install the GajuDesk and
#   GajuMine applications for mining the Gajus
#
# NOTE: This script is intended to be run as a
#   standard user.
# -----------------------------------------------
#!/usr/bin/env bash

function check-fail {
  if [ $1 -ne 0 ];
  then
    echo "ERROR: $2" 1>&2
    exit 10
  fi
}

function install-deb {
    echo "  Installing using Aptitude..."
    sudo apt upgrade 
    sudo apt install -y gcc curl g++ dpkg-dev build-essential automake autoconf \
                        libncurses-dev libssl-dev flex xsltproc libwxgtk3.2-dev \
                        wget vim git
    sudo apt install -y erlang --no-install-recommends
}

function install-rpm {
    echo "  Installing using DNF..."
    sudo dnf upgrade -y
    sudo dnf install -y gcc curl g++ dpkg-dev build-essential automake autoconf \
                        libncurses-dev libssl-dev flex xsltproc libwxgtk3.2-dev \
                        wget vim git
    sudo dnf install -y erlang erlang-tools
}

function install-pacman {
    echo "  Installing using pacman..."
    sudo pacman -S wget erlang erlang-wx --noconfirm
}

function perform-base-install {
    which apt > /dev/null
    has_apt=$?
    which dnf > /dev/null
    has_dnf=$?
    which pacman > /dev/null
    has_pac=$?

    if [ $has_apt -eq 0 ];
    then
        install-deb
    elif [ $has_dnf -eq 0 ];
    then
        install-rpm
    elif [ $has_pac -eq 0 ];
    then
        install-pacman
    else
        echo "Unable to find a usable installer!" 1>&2
        exit 22
    fi
}

echo "Establishing the installer to use..."
perform-base-install

echo "Getting latest Gajumining code..."
mkdir -p ~/git
pushd ~/git > /dev/null
git clone https://github.com/shanepreater/gajumaru.git
pushd gajumaru > /dev/null

echo "Install the Gaju mining software..."
./setup-gaju.sh
check-fail $? "Unable to install the gaju software"

echo "Installing desktop icons..."
./setup-shortcuts.sh
check-fail $? "Unable to create the desktop icons"

echo "Installation complete. Rebooting now..."
sudo reboot now
