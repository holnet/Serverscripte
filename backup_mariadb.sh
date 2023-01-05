#!/bin/bash
# sichert die über Parameter 1 übergebene Datenbank in den Home-Ordner "backups"

# Parameter prüfen
if [[ $# -ne 1 ]]
then
  echo "Syntax: ./backup.mariadb.sh database"
  exit 1
fi

home_folder=~
cd $home_folder
backup_folder=backups
db=$1
backup_file=backup_mariadb_$db-$(date +"%Y%m%d.%H%M%S%N").sql
/usr/bin/logger "Backup - Sicherung von DB $db in $home_folder/$backup_folder/$backup_file"
#
if [ ! -d "$backup_folder" ]
then
  mkdir $backup_folder
  /usr/bin/logger "Backup - Folder $PWD/$backup_folder erstellt"
fi
cd $backup_folder
sql_user=root
sql_password="passwordToChange"
mysqldump -u $sql_user -p$sql_password $db > $backup_file
#echo "***"
#echo -e "DB-Rücksicherung mit :\nmysql -u $sql_user -p $db < $backup_file"
#echo "***"
#
# *** eventuelle alte Backups löschen, das erste file im Monat aufbewahren
#
oldbackups=$(ls ~/backups/ | grep "backup_mariadb_$db" | grep -v "$(date +'%Y%m')")
oldmonthes=$(echo "$oldbackups" | cut -d '-' -f 2 | cut -d '.' -f 1 |cut -c 1-6 | sort | uniq)
#echo  $oldmonthes
for oldmonth in $oldmonthes
do
  month_files=$(ls ~/$backup_folder/backup_mariadb_$db-$oldmonth*.sql)
  delete_files=$(echo "$month_files" | tail -n +2)
  if [ -n "$delete_files" ]
  then
    rm $delete_files
    /usr/bin/logger "Backup - Datei $delete_file veraltet und gelöscht"
  fi
done
#
exit 0