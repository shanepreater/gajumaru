# ----------------------------------
# Script to setup the headless miner as
#   an automatically running service
#   using a specific account.
# ----------------------------------
#!/usr/bin/env bash

FILE="$( realpath $0 )"
INSTALL_DIR="$(dirname $FILE)"

show_usage() {
  echo "$FILE <pubkey> <miners>" 1>&2;
  echo "Where" 1>&2;
  echo "  pubkey - the public key for the mining account to use" 1>&2;
  echo "  miners - the number of concurrent workers to use" 1>&2;
}

write_config() {
  path=$1
  key=$2
  miners=$3
  echo " Writing config to $path with key: $key and miners: $miners"

  echo "{" > $path
  echo "  \"pubkey\": \"$key\"," >> $path
  echo "  \"workers\": [" >> $path
  for i in $(seq $miners); do
    if [ $i -gt 1 ]; then
      echo "    ,{\"executable\": \"mean29-avx2\"}" >> $path
    else
      echo "    {\"executable\": \"mean29-avx2\"}" >> $path
    fi
  done
  echo "  ]" >> $path
  echo "}" >> $path
}

if [ $# -ne 2 ]; then
  show_usage
  echo "Error running script, public key and number of concurrent workers should be passed in." 1>&2;
  exit 1
fi

echo "Setting the run variables"
pubkey=$1
miners=$2
config_dir=/usr/local/gajuminer
config_file=$config_dir/gmhive_client_config.json
service_dir=/etc/systemd/system/
zomp_file=uwiger-gmhive_client

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
#!/usr/bin/env bash
if [ \$# -ge 1 ]; then
  pubkey=\$1
elif [ "\$GM_PUBLIC_KEY" != "" ]; then
  pubkey=\$GM_PUBLIC_KEY
else 
  echo "Public key needs to be passed as either the first argument or via GM_PUBLIC_KEY environment variable" 1>&2;
  exit 1
fi

echo "Ensuring path is consistent..."
PATH=$PATH:$script_path:$erl_path
export PATH

echo "Ensuring everything is up to date"
${script_path}/zx upgrade

echo "Starting mining using public key: "
echo "  ${script_path}/zx run $zomp_file -gmhc pubkey \$pubkey -setup data_dir $config_dir"
${script_path}/zx run $zomp_file -gmhc pubkey \$pubkey -setup data_dir $config_dir
EOF

chmod 755 $script_path/headless-miner.sh

echo "Ensuring the gajuminer directory exists..."
sudo mkdir -p $config_dir
sudo chmod 755 $config_dir

echo "Creating the configuration file..."
write_config ~/config.json $pubkey $miners
sudo cp ~/config.json $config_file
sudo chmod 644 $config_file

echo "Creating the daemon service..."
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
sudo cp ~/gajuminer.service $service_dir
sudo systemctl daemon-reload
sudo systemctl enable gajuminer

echo "Starting the miner..."
sudo systemctl start gajuminer

echo "All done!"
