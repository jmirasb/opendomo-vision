#!/bin/sh
#desc:Stop recording
#package:odvision

# Copyright(c) 2015 OpenDomo Services SL. Licensed under GPL v3 or later

CONFIGDIR="/etc/opendomo/vision"
if test -z "$1"; then
	echo "#ERR Wrong format"
else
	CONFIGFILE=$CONFIGDIR/$1.conf
	if test -f $CONFIGFILE; then
		if test -f /var/opendomo/run/odvision-$1.recording && test -d /media/$STORAGE; then
			source $CONFIGFILE
			rm /var/opendomo/run/odvision-$1.recording
			TIMESTAMP=`date +%s`
			mkdir -p /media/$STORAGE/$1-$TIMESTAMP
			mv /media/$STORAGE/*.* /media/$STORAGE/$1-$TIMESTAMP
			cd /media/$STORAGE/$1-$TIMESTAMP
			tar -cvf $1-$TIMESTAMP.tar *.* && gzip $1-$TIMESTAMP.tar
			echo "#INFO Recording stopped"
			logevent notice odvision "Recording stopped on [$1]"
		else
			echo "#ERR Cannot record"
		fi
	fi
fi 
echo
