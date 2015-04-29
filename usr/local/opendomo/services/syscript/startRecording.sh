#!/bin/sh
#desc:Start recording
#package:odvision

# Copyright(c) 2015 OpenDomo Services SL. Licensed under GPL v3 or later

CONFIGDIR="/etc/opendomo/vision"
if test -z "$1"; then
	echo "#ERR Wrong format"
else
	CONFIGFILE=$CONFIGDIR/$1.conf
	if test -f $CONFIGFILE; then
		source $CONFIGFILE
		if test -d /media/$STORAGE && test -x /media/$STORAGE; then
			echo "#INFO Recording started"
			touch /var/opendomo/run/odvision-$1.recording
			logevent notice odvision "Recording started on [$1]"
		else
			echo "#ERR Invalid storage directory"
		fi
	fi
fi 
echo 