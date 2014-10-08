#!/bin/sh
#desc:Foscam IP camera
#package:odauto

### Copyright(c) 2014 OpenDomo Services SL. Licensed under GPL v3 or later

### This is a bind for foscam and CGI SDK 2.1 based cameras
### You can read more information in http://onlinecamera.net/downloads/foscam-apexis-mjpeg-cgi-sdk.pdf document


# validate device
if test "$1" == "validate"; then
	source "$2"

	# Validation command
    if	wget $URL/ --http-user=$USER --http-password=$PASS -O - &>/dev/null
	then
		# Valid! Determine model and proper URL
		exit 0
	else
		# Invalid. Exit with error code
		exit 1
	fi
fi

if test -f "$1"
then
	source $1
else
	if test -f /etc/opendomo/control/$1.conf
	then
		source /etc/opendomo/control/$1.conf
	else
		echo "#ERROR: Invalid configuration file"
		exit 1
	fi
fi

PIDFILE="/var/opendomo/run/odvision.pid"
TMPFILE=/var/opendomo/tmp/$DEVNAME.tmp
LISTFILE=/var/opendomo/tmp/$DEVNAME.lst
CFGDIR=/etc/opendomo/control
CTRLDIR=/var/opendomo/control

# Preparations:
test -d $CTRLDIR/$DEVNAME/ || mkdir -p $CTRLDIR/$DEVNAME/
test -d $CFGDIR/$DEVNAME/ || mkdir -p $CFGDIR/$DEVNAME/
test -d /var/www/data || mkdir -p /var/www/data

while test -f $PIDFILE
do
	$FULLURL="$URL/snapshot.cgi"
	if	wget -q $FULLURL --http-user=$USER --http-password=$PASS -O $TMPFILE
	then
		if test -f $TMPFILE
		then
			cp $TMPFILE  /var/www/data/$DEVNAME.jpg
			echo >  /var/www/data/$DEVNAME.odauto.tmp

			# Finally, generate JSON fragment
			FILENAME="/data/$DEVNAME.jpg"
			echo "{\"Name\":\"$desc\",\"Type\":\"img\",\"Tag\":\"security\",\"Value\":\"$FILENAME\",\"Min\":\"0\",\"Max\":\"0\",\"Id\":\"$DEVNAME_cam\"}," >> /var/www/data/$DEVNAME.odauto.tmp
		else
			echo "#ERR: The query ended with an error"
			cat $TMPFILE
		fi
	else
		echo "#WARN: ODControl not responding. We will keep trying"
	fi

	# A very quick replacement of the old file with the new one:
	cat /var/www/data/$DEVNAME.odauto.tmp > /var/www/data/$DEVNAME.odauto

	# Cleanup
	rm $TMPFILE
	sleep $REFRESH
done
