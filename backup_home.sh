#!/bin/bash

# Aufruf : ./backup.sh user
#

# sichert den Home-Ordner und excludiert Ordner "backups"
cd ~
home_folder=~
backup_folder=backups
backup_file=backup_home_$1-$(date +"%Y%m%d.%H%M%S%N").tar.bz2
echo "Sicherung in $backup_file"
#
if [ -d "$backup_folder" ]
then
  echo "backup-Folder ist $PWD/$backup_folder"
else
  mkdir $backup_folder
  echo "backup-Folder $PWD/$backup_folder erstellt"
fi
#
#tar -cjf "$backup_folder/$backup_file" --exclude=$backup_folder -C "$home_folder" .
tar -cjf "$backup_folder/$backup_file" \
--exclude=$backup_folder \
--exclude=.cache \
--exclude=backuplog.txt \
-C "$home_folder" .
# *********
#echo '-cjf "$backup_folder/$backup_file" --exclude=$backup_folder -C "$home_folder" .'
#
# entpacken mit: tar -xjf ...
#
# *** eventuelle alte Backups löschen, das erste file im Monat aufbewahren
#
oldbackups=$(ls ~/backups/ | grep "backup_home" | grep -v "$(date +'%Y%m')")
oldmonthes=$(echo "$oldbackups" | cut -d '-' -f 2 | cut -d '.' -f 1 |cut -c 1-6 | sort | uniq)
#echo  $oldmonthes
for oldmonth in $oldmonthes
do
  echo -e "\nBetrachte Monat: $oldmonth"
  month_files=$(ls ~/$backup_folder/backup_home_$USER-$oldmonth*.tar.bz2)
  delete_files=$(echo "$month_files" | tail -n +2)
  #echo "$month_files"
  echo "gelöschte Dateien:"
  echo "$delete_files"
  if [ -n "$delete_files" ]
  then
    rm $delete_files
  else
    echo "nichts zu löschen im Monat $oldmonth"
  fi
done