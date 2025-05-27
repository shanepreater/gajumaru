# --------------------------------------------------
# Script to setup everything needed to begin mining
# --------------------------------------------------
#!/bin/sh
FILE="$( realpath $0 )"
INSTALL_DIR="$(dirname $FILE)"

echo "# 1. Install the ZX system"
wget -q https://zxq9.com/projects/zomp/get_zx && bash get_zx

echo "# 2. Ensure the system is upgraded."
~/bin/zx upgrade

echo "# 3. run Craig's script"
./ubuntu2404/ubuntu_gajumine_prep

echo "# 4. Import the realms"
zx import realm uwiger.zrf
zx import realm qpq.zrf

echo "# 5. Reboot required for the realms to be properly added...."
sudo reboot now

