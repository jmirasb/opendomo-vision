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
	if ! test -z "$1"
	then
		# Display only one zoomed camera
		source $CONFIGDIR/$1.conf
		echo "	-$1	$NAME	zoomedcamera	$DESCRIPTION"
		echo "actions:"
		echo "	goback	Back"		
	else
		# Display all the cameras
		cd $CONFIGDIR
		for f in *.conf
		do
			NAME=""
			DESCRIPTION=""
			ID=`basename $f | cut -f1 -d. `
			source ./$f
			if ! test -z "$NAME"
			then
				echo "	-$ID	$NAME	camera	$DESCRIPTION"
			fi
		done
		echo "actions:"
		if test -x /usr/local/opendomo/manageCameras.sh; then
			echo "	manageCameras.sh	Manage cameras"
		fi
	fi
else
	echo "#ERR: OpenDomo Vision not started"
	echo "actions:"
	echo "	setSystemState.sh	Set system state"
	
fi
echo
