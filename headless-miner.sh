#/usr/bin/env bash
if [ $# -ge 1 ];
  pubky=$1
else
  pubkey=$GM_PUBLIC_KEY
fi

echo "Ensuring everything is up to date"
zx upgrade

echo "Starting mining using public key: $pubkey"
zx run uwiger-gmhive_client -gmhc pubkey $pubkey
