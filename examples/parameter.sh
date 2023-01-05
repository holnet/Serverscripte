#!/bin/bash
#
# Aufruf : ./parameter.sh xxxx yyyy ....
#
# Parameter prüfen
if [[ $# -lt 1 ]]
then
  echo "Syntax: parameter.sh parameter1 [parameter2] ..."
  exit 1
fi
# Parameter auslesen
echo "Name des Scriptes: $(basename $0)" 
echo "Pfad des Scriptes: $(dirname $0)"
echo "Erster Parameter: $1" 
echo "Zweiter Parameter: $2"
echo "Dritter Parameter: $3"
echo "Alle Parameter: $@"
echo "Anzahl der Parameter: $#"