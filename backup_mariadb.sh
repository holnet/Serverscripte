#!/bin/bash

# Aufruf : ./backup.mariadb.sh database
#
# sichert die über Parameter 1 übergebene Datenbank in den Home-Ordner "backups"
cd ~
backup_folder=backups
db=$1
backup_file=backup_mariadb_$db-$(date +"%Y%m%d.%H%M%S%N").sql
echo "DB-Sicherung in $backup_file"
#
if [ -d "$backup_folder" ]
then
  echo "backup-Folder ist $PWD/$backup_folder"
else
  mkdir $backup_folder
  echo "backup-Folder $PWD/$backup_folder erstellt"
fi
cd $backup_folder
sql_user=root
sql_password="passwordToChange"
# To get a list of databases
#databases=`mysql -u $sql_user -p$sql_password -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema)"`
#mysqldump -u $sql_user -p$sql_password inw_wiki | tar -cjf "$backup_folder/$backup_file"
mysqldump -u $sql_user -p$sql_password $db > $backup_file
echo "***"
echo -e "DB-Rücksicherung mit :\nmysql -u $sql_user -p $db < $backup_file"#!/bin/bash
echo "***"
#
# *** eventuelle alte Backups löschen, das erste file im Monat aufbewahren
#
oldbackups=$(ls ~/backups/ | grep "backup_mariadb_$db" | grep -v "$(date +'%Y%m')")
oldmonthes=$(echo "$oldbackups" | cut -d '-' -f 2 | cut -d '.' -f 1 |cut -c 1-6 | sort | uniq)
#echo  $oldmonthes
for oldmonth in $oldmonthes
do
  echo -e "\nBetrachte Monat: $oldmonth"
  month_files=$(ls ~/$backup_folder/backup_mariadb_$db-$oldmonth*.sql)
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