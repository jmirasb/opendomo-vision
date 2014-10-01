#!/bin/sh
#desc:View cameras
#package:odvision
#type:local

# Copyright(c) 2014 OpenDomo Services SL. Licensed under GPL v3 or later

PIDFILE="/var/opendomo/run/odvision.pid"
CONFIGDIR="/etc/opendomo/vision"

echo "#>View cameras"
echo "list:`basename $0`	iconlist"

if test -f $PIDFILE && test -d $CONFIGDIR
then
	cd $CONFIGDIR
	for f in *.conf
	do
		NAME=""
		DESCRIPTION=""
		source ./$f
		if ! test -z "$NAME"
		then
			echo "	-$NAME	$NAME	camera	$DESCRIPTION"
		fi
	done
else
	echo "#ERR: OpenDomo Vision not started"
	echo "actions:"
	echo "	setSystemState.sh	Set system state"
	
fi
echo
