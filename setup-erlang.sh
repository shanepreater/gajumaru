# ------------------------------------------------------------
# Installation of Erlang including Wx support for Ubuntu 24.04
# ------------------------------------------------------------
#!/bin/sh 

# 1. Install the pre-reqs before using RabbitMQ's setup
apt install -y net-tools software-properties-common curl apt-transport-https lsb-release

# 2. Download the Rabbit setup script to ensure the correct package sources are available
wget 'https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/setup.deb.sh'
chmod 755 ./setup.deb.sh
./setup.deb.sh

# 3. Install ErLang and the Wx libraries
apt install -y erlang libwxgtk3.2-dev

echo Erlang is installed

