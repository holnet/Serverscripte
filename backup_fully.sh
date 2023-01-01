#!/bin/bash

cd /
tar -cvpjf /home/holger/backups/backup_fully-$(date +%d.%m.%Y).tar.bz2 \
--exclude=/proc \
--exclude=/tmp \
--exclude=/mnt \
--exclude=/dev \
--exclude=/sys \
--exclude=/run \
--exclude=/media \
--exclude=/var/log \
--exclude=/swapfile \
--exclude=/home/holger/backups \
--exclude=/backup /
