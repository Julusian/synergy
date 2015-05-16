#!/bin/bash

#we check the local dirs exist
if [ ! -d "$HOME/.synergy" ]; then
  mkdir "$HOME/.synergy"
fi
if [ ! -d "$HOME/.synergy/plugins" ]; then
  mkdir "$HOME/.synergy/plugins" 
fi

SRC="/usr/lib/synergy/plugins/libns.so"
DEST="$HOME/.synergy/plugins/libns.so"

#first we check if the plugin is up to date
if diff $SRC $DEST 2>&1 >/dev/null ; then
  echo "SSL Plugin is up to date"
else
  echo "Updating SSL Plugin";

  cp $SRC $DEST
fi

#then we check if there is a certificate
if [ ! -d "$HOME/.synergy/SSL" ]; then
  mkdir "$HOME/.synergy/SSL" 
fi
if [ ! -f "$HOME/.synergy/SSL/Synergy.pem" ]; then
  echo "Generating certificate"

  mkdir -p "$HOME/.synergy/SSL/Fingerprints"
  openssl req -x509 -nodes -days 365 -subj /CN=Synergy -newkey rsa:1024 -keyout "$HOME/.synergy/SSL/Synergy.pem" -out "$HOME/.synergy/SSL/Synergy.pem"
  openssl x509 -fingerprint -sha1 -noout -in "$HOME/.synergy/SSL/Synergy.pem" > "$HOME/.synergy/SSL/Fingerprints/Local.txt"
  sed -e "s/.*=//" -i "$HOME/.synergy/SSL/Fingerprints/Local.txt"
else
  echo "Certificate found"
fi

#then we start the normal program
echo "Starting Program"
synergy
