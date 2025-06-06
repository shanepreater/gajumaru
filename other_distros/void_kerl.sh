#!/bin/sh

sudo xbps-install -y curl wget git gcc autoconf make libxslt noto-fonts-ttf \
    wxWidgets-gtk3-devel openssl-devel ncurses-devel glu-devel

mkdir ~/bin
ln -s /usr/bin/wx-config-gtk3 ~/bin/wx-config
export PATH=$PATH:$HOME/bin

curl -O https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod a+x kerl
./kerl build 27.3.4 27.3.4
./kerl install 27.3.4 ~/.erts/27.3.4
echo '. "$HOME"/.erts/27.3.4/activate' >> .bashrc
. ~/.erts/27.3.4/activate

wget -q https://zxq9.com/projects/zomp/get_zx && bash get_zx

zx import realm ~/install_scripts/qpq.zrf
zx import realm ~/install_scripts/uwiger.zrf
zx run qpq-gajumine
