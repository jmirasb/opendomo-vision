#!/bin/sh
### BEGIN INIT INFO
# Provides:          odvision
# Required-Start:    
# Required-Stop:
# Should-Start:      
# Default-Start:     1 2 3 4 5
# Default-Stop:      0 6
# Short-Description: Vision
# Description:       Vision
#
### END INIT INFO

# Copyright(c) 2015 OpenDomo Services SL. Licensed under GPL v3 or later

. /lib/lsb/init-functions
DESC="Vision"
PIDFILE="/var/opendomo/run/odvision.pid"
REFRESH="2"
CONFIGDIR="/etc/opendomo/vision"
#FIXME Use configured directory:
RECORDINGS="/media/recording"

#This is the actual daemon service
do_daemon() {
	# Preparations
	test -d $CONFIGDIR || mkdir -p $CONFIGDIR
	
	for i in /dev/video*
	do
		if test "$i" != "/dev/video*"
		then	
			cname=`basename $i`
			if ! test -f $CONFIGDIR/$cname.info
			then
				echo "NAME=$cname" > $CONFIGDIR/$cname.info
				echo "DEVICE=$i" >> $CONFIGDIR/$cname.info
				echo "TYPE=local" >> $CONFIGDIR/$cname.info
			fi
		fi
	done
	

	
	while test -f $PIDFILE
	do
		cd $CONFIGDIR
		TIMESTAMP=`date +%s`
		for i in *.conf
		do
			TYPE="ip"
			ID=`basename $i | cut -f1 -d.`
			source ./$i
			# For all the cameras, shift current snapshot with previous
			cp /var/www/data/$ID.jpg /var/www/data/prev_$ID.jpg 2>/dev/null
			
			# If camera is set to recording
			if test -f /var/opendomo/run/odvision-$ID.recording; then
				cp /var/www/data/$ID.jpg  /media/$STORAGE/$TIMESTAMP.jpg
			fi
			
			if test $TYPE = "local"
			then
				# If the camera is local (USB attached) extract image
				if ! fswebcam -d $DEVICE -r 640x480 /var/www/data/$ID.jpg ; then 
					cp /var/www/images/nocam.jpeg /var/www/data/${ID}.jpg
				fi
				# Only for the local cameras, notify the event
				logevent camchange odvision "Updating snapshot" /var/www/data/$ID.jpg
			fi
			
			# Check if filters are configured and run them
			if test -d $CONFIGDIR/$ID/filters; then
				for fil in $CONFIGDIR/$ID/filters/*.conf; do
					IDF=`basename $fil | cut -f1 -d.`
					# source ./$f
					if ! python $FILTERSDIR/$IDF/$IDF.py $ID; then
						cp /var/www/images/nofilter.jpg /var/www/data/${ID}_${IDF}.jpg
					fi
					# no in daemon logevent $IDF opencvodos "Motion detected in $ID" 
				done				
			fi
		done
		sleep $REFRESH
	done
}


do_start() {
	echo 1 > $PIDFILE
	$0 daemon &
}
do_stop() {
	rm $PIDFILE
}

case "$1" in
	daemon)
		do_daemon
	;;

	start)
        log_daemon_msg "Starting $DESC" "$NAME"
		/usr/local/opendomo/daemons/odauto.sh restart 2>/dev/null
        do_start
        log_end_msg 0
    ;;
	stop)
        log_daemon_msg "Stopping $DESC" "$NAME"
        do_stop
        log_end_msg 0
    ;;
	status)
        test -f $PIDFILE && exit 0 || exit $?
    ;;
	reload|force-reload|restart|force-reload)
        do_stop
		do_start
    ;;
	*)
        echo "Usage: $0 {start|stop|status|restart|force-reload}"
        exit 3
    ;;
esac
