#!/bin/bash
# sichert den Home-Ordner und excludiert die Ordner "backups" und ".cache"

# Parameter prüfen
if [[ $# -ne 1 ]]
then
  echo "Syntax: backup_home.sh user"
  exit 1
fi

home_folder=~
cd $home_folder
backup_folder=backups
backup_file=backup_home_$1-$(date +"%Y%m%d.%H%M%S%N").tar.bz2
/usr/bin/logger "Backup - Sicherung in $home_folder/$backup_folder/$backup_file"
#
if [ ! -d "$backup_folder" ]
then
  mkdir $backup_folder
  /usr/bin/logger "Backup - Folder $PWD/$backup_folder erstellt"
fi
#
#tar -cjf "$backup_folder/$backup_file" --exclude=$backup_folder -C "$home_folder" .
tar -cjf "$backup_folder/$backup_file" \
--exclude=$backup_folder \
--exclude=.cache \
--exclude=backuplog.txt \
-C "$home_folder" .
# *********
# entpacken mit: tar -xjf ...
# *********
#
# eventuelle alte Backups löschen, das erste file im Monat aufbewahren
#
oldbackups=$(ls ~/backups/ | grep "backup_home" | grep -v "$(date +'%Y%m')")
oldmonthes=$(echo "$oldbackups" | cut -d '-' -f 2 | cut -d '.' -f 1 |cut -c 1-6 | sort | uniq)
for oldmonth in $oldmonthes
do
  month_files=$(ls ~/$backup_folder/backup_home_$USER-$oldmonth*.tar.bz2)
  delete_files=$(echo "$month_files" | tail -n +2)
  if [ -n "$delete_files" ]
  then
    rm $delete_files
    /usr/bin/logger "Backup - Datei $delete_file veraltet und gelöscht"
  fi
done
#
exit 0