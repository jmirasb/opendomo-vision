#!/bin/sh
#desc:Stop recording
#package:odvision

CONFIGDIR="/etc/opendomo/vision"
#FIXME Use configured directory:
RECORDINGS="/media/recording"
if test -z "$1"; then
	echo "#ERR Wrong format"
else
	CONFIGFILE=$CONFIGDIR/$1.conf
	if test -f $CONFIGFILE; then
		TIMESTAMP=`date +%s+`
		mv $RECORDINGS/$1 $RECORDINGS/$1-$TIMESTAMP
		cd $RECORDINGS/$1-$TIMESTAMP/
		tar -cvf $1-$TIMESTAMP.tgz *.jpg
		logevent notice odvision "Recording stopped on [$1]"
	fi
	if test -d $RECORDINGS/$1/; then
		echo "#INFO Recording stopped"
	else
		echo "#ERR Cannot record"
	fi
fi 
echo
