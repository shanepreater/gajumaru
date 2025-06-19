#!/bin/sh

sudo apt -y install wget erlang --no-install-recommends

wget -q https://zxq9.com/projects/zomp/get_zx && bash get_zx
export PATH=$PATH:$HOME/bin

zx import realm install_scripts/qpq.zrf
zx import realm install_scripts/uwiger.zrf
zx run qpq-gajumine
