#!/bin/sh
#desc:View cameras
#package:odvision
#type:local

# Copyright(c) 2014 OpenDomo Services SL. Licensed under GPL v3 or later

PIDFILE="/var/opendomo/run/odvision.pid"
CONFIGDIR="/etc/opendomo/vision"

if test -f $PIDFILE && test -d $CONFIGDIR
then
	echo "#>View cameras"
	echo "list:`basename $0`	iconlist"
	cd $CONFIGDIR
	for f in *.conf
	do
		NAME=""
		source ./$f
		if ! test -z "$NAME"
		then
			echo "	-$NAME	$NAME	image	/data/$NAME.jpeg"
		fi
	done
else
	echo "#ERR: OpenDomo Vision not configured"
	echo
fi
