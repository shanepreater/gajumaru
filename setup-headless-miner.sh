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

echo "Getting the run script..."
if [ -f ./headless-miner.sh]; then
  echo "Already have the required scripts"
else
  echo "Pulling in the scripts."
  wget https://raw.githubusercontent.com/shanepreater/gajumaru/refs/heads/main/headless-miner.sh
fi
cp headless-miner ~/bin

echo "Creating the systemctl service config..."
script_path=$(realpath "~/bin") && dirname $script_path 

cat > ~/gajumining.service <<EOF
[Unit]
Description=Headless Gajumaru mining service

[Service]
ExecStart=/bin/bash $script_path/headless-miner.sh $pubkey

[Install]
WantedBy=multi-user.target
EOF

echo "enabling the service for automatic execution..."
sudo cp ~/gajumining.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable gajumining

echo "Starting the miner..."
sudo systemctl start gajumining

echo "All done!"
