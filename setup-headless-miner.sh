# ----------------------------------
# Script to setup the headless miner as
#   an automatically running service
#   using a specific account.
# ----------------------------------
#!/usr/bin/env bash

FILE="$( realpath $0 )"
INSTALL_DIR="$(dirname $FILE)"

if [ $# -ne 1 ]; then
  echo "Error running script, public key should be passed as the only argument!" 1>&2;
  exit 1
fi

echo "Setting the public key..."
pubkey=$1

echo "Checking the zomp/zx is installed..."
found=$(which zx)
if [ $? -ne 0 ]; then
  echo "zx not installed, run:" 1>&2;
  echo "  wget https://raw.githubusercontent.com/shanepreater/gajumaru/refs/heads/main/quick-start.sh  && bash quick-start.sh" 1>&2;
  exit 2
fi

echo "checking we have git installed...."
found=$(which git)
if [ $? -ne 0 ]; then
  echo "Git not installed, run:" 1>&2;
  echo "  wget https://raw.githubusercontent.com/shanepreater/gajumaru/refs/heads/main/quick-start.sh  && bash quick-start.sh" 1>&2;
  exit 2
fi

echo "Creating the run script..."
script_path="$HOME/bin"
erl=$(which erl)
erl_path=$(dirname $erl)
cat > $script_path/headless-miner.sh <<EOF
if [ $# -ge 1 ]; then
  pubky=$1
else
  pubkey=$GM_PUBLIC_KEY
fi

echo "Ensuring everything is up to date"
${script_path}/zx upgrade

echo "Starting mining using public key: $pubkey"
${script_path}/zx run uwiger-gmhive_client -gmhc pubkey $pubkey
EOF
chmod 755 $script_path/headless-miner.sh

cat > ~/gajuminer.service <<EOF
[Unit]
Description=Headless Gajumaru mining service

[Service]
Type=Simple
User=$USER
Environment=PATH=$PATH:$script_path:$erl_path
ExecStart=/bin/bash $script_path/headless-miner.sh $pubkey

[Install]
WantedBy=multi-user.target
EOF

echo "enabling the service for automatic execution..."
sudo cp ~/gajuminer.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable gajuminer

echo "Starting the miner..."
sudo systemctl start gajuminer

echo "All done!"
