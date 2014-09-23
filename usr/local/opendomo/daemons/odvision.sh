#!/bin/sh
#desc:Vision

DESC="Vision"
PIDFILE="/var/opendomo/run/odvision.pid"
REFRESH="2"

#This is the actual daemon service
do_daemon() {
	while test -f $PIDFILE
	do
		for i in /dev/video*
		do
			if test "$i" != "/dev/video*"
			then
				cname=`basename $i`
				fswebcam -d $i -r 640x480 /var/www/data/$cname.jpeg
			fi
		done
		sleep $REFRESH
	done
}


do_start() {
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
