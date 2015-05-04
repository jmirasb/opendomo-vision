#!/bin/sh
#desc:View cameras
#package:odvision
#type:local

# Copyright(c) 2015 OpenDomo Services SL. Licensed under GPL v3 or later

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
		echo "	-$1	$DESCRIPTION	zoomedcamera	$DESCRIPTION"
		echo "actions:"
		echo "	goback	Back"		
	else
		# Display all the cameras
		cd $CONFIGDIR
		for f in *.conf
		do
			NAME=""
			DESCRIPTION=""
			STATUS=""
			FILTERS=""
			ID=`basename $f | cut -f1 -d. `
			source ./$f
			if ! test -z "$NAME"
			then
				test -f /var/opendomo/run/odvision-$1.recording && STATUS="$STATUS recording"
				if test -d /etc/opendomo/vision/$ID/filters/; then
					for i in /etc/opendomo/vision/$ID/filters/*.conf; do
						F=`basename $i | cut -f1 -d.`
						FILTERS="$FILTERS $F"
					done
				fi
				echo "	-$ID	$DESCRIPTION	camera $STATUS	$FILTERS"
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
