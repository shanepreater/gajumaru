# -----------------------------------------------
# Quick start simpler one script installer
#   This script will install the GajuDesk and
#   GajuMine applications for mining the Gajus
#
# NOTE: This script is intended to be run as a
#   standard user.
# -----------------------------------------------
#!/usr/bin/env bash

FILE="$( realpath $0 )"
INSTALL_DIR="$(dirname $FILE)"

pushd ~ > /dev/null
echo "Ensuring system is up to date...."
sudo apt upgrade

echo "Installing baseline components..."
sudo apt install -y net-tools software-properties-common curl apt-transport-https lsb-release \
     gcc curl g++ dpkg-dev build-essential automake autoconf libncurses-dev libssl-dev flex xsltproc libwxgtk3.2-dev wget vim git

mkdir -p ~/vcs ~/bin
echo "Setting up Kerl..."
pushd ~/vcs
git clone https://github.com/kerl/kerl.git
ln -s ~/vcs/kerl/kerl ~/bin/kerl
kerl/kerl update releases
kerl/kerl build 27.3.4 27.3.4
kerl/kerl install 27.3.4 ~/.erts/27.3.4
popd > /dev/null

echo "Updating the bashrc with the appropriate scripts..."

echo '. "$HOME"/.erts/27.3.4/activate' >> .bashrc
. ~/.erts/27.3.4/activate

echo "Installing ErLang..."
wget 'https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/setup.deb.sh'
chmod 755 ./setup.deb.sh
./setup.deb.sh
sudo apt install -y erlang libwxgtk3.2-dev

echo "Install the ZX framework..."
wget -q https://zxq9.com/projects/zomp/get_zx && bash get_zx

echo "# 2. Ensure the system is upgraded."
~/bin/zx upgrade

echo "Cloning the Gajumaru scripts repo..."
git clone https://github.com/shanepreater/gajumaru.git
pushd gajumaru > /dev/null

echo "Install the correct realms..."
zx import realm uwiger.zrf
success=$?
zx import realm qpq.zrf

echo "Setup the Gnome shortcuts..."
echo "# 1. Setup the Desktop links"
cat > ~/Desktop/GajuDesk.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Gaju Desktop
Comment=Desktop Wallet for the Gajumaru
Exec=${INSTALL_DIR}/gajudesk.sh
EOF

echo "# 2. Setup the Mining UI"
cat > ~/Desktop/GajuMine.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Gaju Miner
Comment=Interactive Miner for the Gajumaru
Exec=${INSTALL_DIR}/gajumine.sh
EOF

if [ $success -ne 0 ];
  echo "Error running script!. See output above." 1>&2;
  exit 1
else
  echo "All done. Rebooting..."
  sudo reboot now
fi

