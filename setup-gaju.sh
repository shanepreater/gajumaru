# --------------------------------------------------
# Script to setup everything needed to begin mining
# --------------------------------------------------
#!/bin/sh
FILE="$( realpath $0 )"
INSTALL_DIR="$(dirname $FILE)"

function check-fail {
  if [ $1 -ne 0 ];
  then
    echo "ERROR: $2" 1>&2
    exit 10
  fi
}

echo "# 1. Install the ZX system"
wget -q https://zxq9.com/projects/zomp/get_zx && bash get_zx

echo "# 2. Ensure the system is upgraded."
~/bin/zx upgrade

echo "# 3. run Craig's script"
./ubuntu2404/ubuntu_gajumine_prep

echo "# 4. Import the realms"


zx import realm uwiger.zrf
check-fail $? "Unable to install the uwiger realm"
zx import realm qpq.zrf
check-fail $? "Unable to install the qpq realm"

