#!/bin/sh

sudo apt update
sudo apt upgrade
sudo apt -y install \
    gcc curl g++ dpkg-dev build-essential automake autoconf \
    libncurses-dev libssl-dev flex xsltproc libwxgtk3.2-dev \
    wget vim git

curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod a+x kerl
./kerl build 27.3.4 27.3.4
./kerl install 27.3.4 ~/.erts/27.3.4
echo '. "$HOME"/.erts/27.3.4/activate' >> .bashrc
. ~/.erts/27.3.4/activate

wget -q https://zxq9.com/projects/zomp/get_zx && bash get_zx
export PATH=$PATH:$HOME/bin

zx import realm ~/install_scripts/qpq.zrf
zx import realm ~/install_scripts/uwiger.zrf
zx run qpq-gajumine
