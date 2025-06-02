#/usr/bin/env bash
script_path="$HOME/bin"

if [ $# -ge 1 ]; then
  pubky=$1
else
  pubkey=$GM_PUBLIC_KEY
fi

echo "Ensuring everything is up to date"
${script_path}/zx upgrade

echo "Starting mining using public key: $pubkey"
${script_path}/zx run uwiger-gmhive_client -gmhc pubkey $pubkey
