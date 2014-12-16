#!/bin/sh
#desc:Start recording
#package:odvision

CONFIGDIR="/etc/opendomo/vision"
#FIXME Use configured directory:
RECORDINGS="/media/recording"
if test -z "$1"; then
	echo "#ERR Wrong format"
else
	CONFIGFILE=$CONFIGDIR/$1.conf
	if test -f $CONFIGFILE; then
		mkdir -p $RECORDINGS/$1/
		logevent notice odvision "Recording started on [$1]"
	fi
	if test -d $RECORDINGS/$1/; then
		echo "#INFO Recording started"
	else
		echo "#ERR Cannot record"
	fi
fi 
echo