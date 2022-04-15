#!/bin/bash

## Ubuntu Update with APT and SNAP
function upubuntu(){

	local log="/var/log/everydays20.log"

	## APT
	echo "$(date +%F-%T.%N) - [APT] Mise à jour de la DB" >> $log
	apt update >> $log
	echo "$(date +%F-%T.%N) - [APT] Mise à jour des paquets" >> $log
	apt full-upgrade -y >> $log
	echo "$(date +%F-%T.%N) - [APT] Nettoyage" >> $log
	apt autoremove --purge >> $log
	apt clean >> $log
	apt autoclean >> $log

	## SNAP
	echo "$(date +%F-%T.%N) - [SNAP] Mise à jour des paquets" >> $log
	snap refresh >> $log

}

function backupweb(){

	local log="/var/log/everydays20.log"
	local backup="var/backupweb/html-$(date +%F%T%N).tgz"
	local web="var/www/html/"

	echo "$(date +%F-%T.%N) - [BACKUPWEB] - Execution de la backup vers /$backup" >> $log
	cd /
	tar czvf $backup $web >> $log

}

upubuntu
backupweb
exit 0
