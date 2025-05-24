# --------------------------------------------------
# Script to setup everything needed to begin mining
# --------------------------------------------------
#!/bin/sh
FILE="$( realpath $0 )"
INSTALL_DIR="$(dirname $FILE)"

echo "File is $FILE and directory is $INSTALL_DIR"

# 1. Install the ZX system
wget -q https://zxq9.com/projects/zomp/get_zx && bash get_zx

# 2. Import the realms
zx import realm uwiger.zrf
zx import realm qpq.zrf

# 3. Setup the Desktop links
cat > ~/Desktop/GajuDesk.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Gaju Desktop
Comment=Desktop Wallet for the Gajumaru
Exec=$INSTALL_DIR/gajudesk.sh
EOF
