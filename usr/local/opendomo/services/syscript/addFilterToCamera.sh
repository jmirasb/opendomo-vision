#!/bin/sh
#desc: Add filter to Camera 
#package:odvision
#type:local

# Copyright(c) 2015 OpenDomo Services SL. Licensed under GPL v3 or later

DEVNAME="opencvodos"
CONFIGDIR="/etc/opendomo/vision"
CAMDIR="/etc/opendomo/control/"

if ! test -z "$2"
then
	if test -f $CONFIGDIR/$1.conf
	then
		ID="$1"
		filter="$2"
		FILENAME="$CONFIGDIR/$ID/filters/$filter.conf"
		echo "[Definition]" > $FILENAME
		echo "ID=$ID" >> $FILENAME
		echo "NAME='$filter'" >> $FILENAME
		echo "#INFO Filter created $FILENAME"
	else
		echo "#INFO No cameras were found, in OpenCVODOS"
	fi
else
	cd $CAMDIR
	for i in *.conf; 
	do
	if test "$i" = "*.conf"
	then
		echo "#INFO No cameras were found"
		echo "actions:"
		echo "	configureOpenCVODOS.sh "
		echo
		exit 0
	fi
	source ./$i
	ID=`basename $i | cut -f1 -d.`
	echo "-ID:$ID	Name: Filter"
	done
	echo "Usage: $0 [ID] [Name]"
fi
