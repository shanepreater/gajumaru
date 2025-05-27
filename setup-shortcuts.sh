# Setup the Desktop shortcuts for the software.
# =============================================
#!/bin/sh

FILE="$( realpath $0 )"
INSTALL_DIR="$(dirname $FILE)"

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

