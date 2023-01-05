#!/bin/bash
# legt für die übergebenen User ein Benutzerkonto an

# Parameter prüfen
if [[ $# -lt 1 ]]
then
  echo "Syntax: ./adding-user.sh user1 [user2] [user3] ..."
  exit 1
fi
# Root oder nicht Root ?
if [[ $UID -ne 0 ]]
then
  echo "Das Script läuft nicht mit Root-Rechten !"
  exit 1
fi

# User anlegen
for user in $@
do
  counter=$((counter+1))
  # Den vollständigen Namen abfragen
  read -p "Bitte den vollständigen Namen für $user eingeben: " comment
  # Das Passwort generieren
  password=$(echo "$(date +%s%N)$RANDOM" | sha512sum | head -c8)
  # den Benutzer anlegen mit Homeverzeichnis (-m) und der Shell "bash"
  useradd -m -c "$comment" -s /bin/bash $user
  # das Passwort setzen
  echo "$user:$password" | chpasswd
  # das erstemal bei der Anmeldung muss das Passwort geändert werden
  passwd -e $user
  # ... und anzeigen
  echo "Das Passwort für User $user ist : $password"
  if [[ $counter != $# ]]
  then
    echo -e "\nnächster User: "
  fi
done
#
exit 0