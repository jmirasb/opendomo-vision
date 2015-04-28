#!/bin/sh
#desc:Axis IP camera
#package:odvision

### Copyright(c) 2014 OpenDomo Services SL. Licensed under GPL v3 or later

test -d /etc/opendomo/vision || mkdir /etc/opendomo/vision

# validate device
if test "$1" == "validate"; then
	source "$2"

	# Validation command
    if	wget $URL/axis-cgi/jpg/image.cgi --http-user=$USER --http-password=$PASS -O - &>/dev/null
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

touch /etc/opendomo/vision/$DEVNAME.conf

# Preparations:
test -d $CTRLDIR/$DEVNAME/ || mkdir -p $CTRLDIR/$DEVNAME/
test -d $CFGDIR/$DEVNAME/ || mkdir -p $CFGDIR/$DEVNAME/
test -d /var/www/data || mkdir -p /var/www/data

logevent notice odvision "Starting camera [$DEVNAME]"
while test -f $PIDFILE
do
	# Take the snapshot (see http://www.axis.com/techsup/cam_servers/tech_notes/live_snapshots.htm)
	FULLURL="$URL/axis-cgi/jpg/image.cgi?resolution=320x240"
	if	wget -q $FULLURL --http-user=$USER --http-password=$PASS -O $TMPFILE
	then
		if test -f $TMPFILE
		then
			cp -vf $TMPFILE  /var/www/data/$DEVNAME.jpg
			echo >  /var/www/data/$DEVNAME.odauto.tmp
			
			# Finally, generate JSON fragment
			FILENAME="/data/$DEVNAME.jpg"
			echo "{\"Name\":\"$desc\",\"Type\":\"img\",\"Tag\":\"security\",\"Value\":\"$FILENAME\",\"Min\":\"0\",\"Max\":\"0\",\"Id\":\"$DEVNAME_cam\"}," >> /var/www/data/$DEVNAME.odauto.tmp
		else	
			echo "#ERR: The query ended with an error"
			cat $TMPFILE
		fi
	
	else
		logevent notice odvision "Camera [$DEVNAME] failed"
		echo "#WARN: Camera not responding. We will keep trying"
	fi
	
	# A very quick replacement of the old file with the new one:
	cat /var/www/data/$DEVNAME.odauto.tmp > /var/www/data/$DEVNAME.odauto
	
	# Cleanup
	rm $TMPFILE 
	sleep $REFRESH
done
logevent notice odvision "Closing camera [$DEVNAME]"