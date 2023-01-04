#!/bin/bash
#
# Aufruf : ./adding-user.sh
#
# 
#

# Root oder nicht Root ?
if [[ $UID -ne 0 ]]
then
  echo "Das Script läuft nicht mit Root-Rechten !"
  exit 1
fi

# Den Login-Namen abfragen
read -p 'Bitte den Login-Namen eingeben: ' username

# Den vollständigen Namen abfragen
read -p 'Bitte den vollständigen Namen eingeben: ' comment

# Das Passwort abfragen
read -p 'Bitte das Passwort eingeben: ' password

# den Benutzer anlegen
useradd -m -c "$comment" -s /bin/bash $username

# das Passwort setzen
echo "$username:$password" | chpasswd
