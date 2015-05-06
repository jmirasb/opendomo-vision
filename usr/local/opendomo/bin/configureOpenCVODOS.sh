#!/bin/sh
#desc:Configure OpenCVODOS
#package:odvision
#type:local

# Copyright(c) 2015 OpenDomo Services SL. Licensed under GPL v3 or later

DEVNAME="opencvodos"
CONFIGDIR="/etc/opendomo/vision"
CAMDIR="/etc/opendomo/control"

# test -d $CONFIGDIR || mkdir $CONFIGDIR


if ! test -z "$2"
then
	if test -f $CAMDIR/$1.conf
	then
		ID="$1"
		NAME="$2"
		test -d $CONFIGDIR/$ID/filters/ || mkdir -p $CONFIGDIR/$ID/filters/
		FILENAME="$CONFIGDIR/$ID.conf"
		echo "ID=$ID" > $FILENAME
		echo "NAME='$NAME'" >> $FILENAME
	else
		echo "#INFO No cameras were found, with ID:$1"
	fi
else
	cd $CAMDIR
	for i in *.conf; 
	do
	if test "$i" = "*.conf"
	then
		echo "#INFO No cameras were found"
		echo "actions:"
		echo "	addControlDevice.sh "
		echo
		exit 0
	fi
	source ./$i
	ID=`basename $i | cut -f1 -d.`
	echo "-ID:$ID	Name: $NAME"
	done
	echo "Usage: $0 [ID] [Name]"
fi
