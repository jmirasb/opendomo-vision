#!/bin/sh
#desc: Remove filter from camera
#package:odvision
#type:local

# Copyright(c) 2015 OpenDomo Services SL. Licensed under GPL v3 or later

DEVNAME="opencvodos"
CONFIGDIR="/etc/opendomo/vision"
CAMDIR="/etc/opendomo/control/"

#ID="$1"
#NAME="$2"
	
if ! test -z "$2"
then
	ID="$1"
	filter="$2"
	FILENAME="$CONFIGDIR/$ID/filters/$filter.conf"
	if test -f $FILENAME
	then
		rm $FILENAME
	else
		echo "#INFO No filters were found in $FILENAME"
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
