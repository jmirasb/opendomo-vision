#!/bin/sh
#desc:Cameras management
#package:odvision
#type:local

# Copyright(c) 2014 OpenDomo Services SL. Licensed under GPL v3 or later

PIDFILE="/var/opendomo/run/odvision.pid"
CONFIGDIR="/etc/opendomo/vision"


test -d $CONFIGDIR || mkdir $CONFIGDIR

cd $CONFIGDIR


if test -z "$1"; then
	echo "#> Manage cameras"
	echo "list:manageCameras.sh	detailed"
	for i in *.conf
	do
		if test "$i" = "*.conf"
		then
			echo "#INFO No cameras were found"
			echo "actions:"
			echo "	addControlDevice.sh	Add camera"
			echo
			exit 0
		fi
		source ./$i
		ID=`basename $i | cut -f1 -d.`
		echo "	-$ID	$NAME	camera $TYPE	$DESCRIPTION"
	done
	echo "actions:"
	echo "	addControlDevice.sh	Add camera"
else
	camID=$1
	if ! test -z "$NAME" && ! test -z "$DESCRIPTION"; then
		echo "NAME=$NAME" > $CONFIGDIR/$camID.conf
		echo "DESCRIPTION='$DESCRIPTION'" >> $CONFIGDIR/$camID.conf
	fi

	test -f $CONFIGDIR/$camID.conf && source $CONFIGDIR/$camID.conf
	echo "#> Edit camera"
	echo "form:manageCameras.sh"
	echo "	code	Code	hidden	$camID"
	echo "	name	Name	hidden	$NAME"
	echo "	desc	Description	text	$DESCRIPTION"
	echo "actions:"
	echo "	goback	Back"
	echo "	manageCameras.sh	Save changes"
	echo
	if test -d /usr/local/opendomo/filters; then
		echo "#>Filters"
		echo "list:`basename $0`	listbox selectable"
		cd /usr/local/opendomo/filters
		for filter in *; do
			desc=`grep '#desc:' $filter/$filter.py | cut -f2 -d:`
			if test -f /etc/opendomo/vision/$1/filters/$filter.conf; then
				echo "	$filter	$desc	filter selected"
			else
				echo "	$filter	$desc	filter"			
			fi
		done
		echo "actions:"
		echo "	saveSettings	Save settings"
	fi
fi
echo

exit 0 #DEPRECATED CODE:

# Common video module vars
if ! test -f "/etc/opendomo/videoConfVars.conf"; then
   cp /etc/opendomo/videoConfVars.conf.orig /etc/opendomo/videoConfVars.conf
fi
. "/etc/opendomo/videoConfVars.conf"

if ! test -f "/etc/opendomo/video/common.conf"; then
   cp /etc/opendomo/video/common.conf.orig /etc/opendomo/video/common.conf
fi



# Lib config
. "$LIB_CONFIG"
# Lib Net
. "$LIB_NET"
# ----------------------------------------------------------------------------
# desc: Manage cameras
# author: Isidro Catalan &lt;skarvin@gmail.com&gt;, http://www.opendomo.org
# date: May 2011
#
# CHANGES:
# ----------------------------------------------------------------------------

if [ ! -d "$ZONEDIR" ]; then
	mkdir "$ZONEDIR" 2&gt;/dev/null
fi

if [ -w "$VIDEO_CONF_PATH/$cam_code.conf" ] &amp;&amp; [ "$cam_name" != "" ]; then
	no_spaces_name=`echo $cam_name | tr " +áéíóúÑñÁÉÍÓÚÀÈÌÒÙ" "__aeiounNnAEIOUAEIOU"`
	NEW_CONF_FILE="$VIDEO_CONF_PATH/$no_spaces_name.conf"
	CONF_FILE="$VIDEO_CONF_PATH/$cam_code.conf"
	url_ok="no"

	if [ "$netcam_user" != "" ] ||  [ "$netcam_pass" != "" ]; then
		# echo "#INF: Skipping URL validation, http authentication enabled"
		url_ok="yes"
	else
		# Check whether the URL is valid
#		TRIMURL=`echo $netcam_url | cut -f3- -d'/'`
		if wget -sq "$netcam_url"
		then
			echo "#INF: Camera successfuly configured!"
		else
			echo "#ERR: The Url provided seems not to be working or the http authentication is enabled, please check it and try it again"
			exit 1
		fi
	fi

	if [ "$url_ok" = "yes" ]; then  
		setValue "URL" "$netcam_url"
	if [ "$netcam_user" != "" ] || [ "$netcam_pass" != "" ]; then
		setValue "AUTH" "$netcam_user:$netcam_pass"	
	else
		setValue "AUTH" ""	
	fi
		setValue "ZONE" "$cam_zone" 
		setValue "NAME" "$cam_name" 
		setValue "NIGHT_VISION" "$night_vision" 
		setValue "SENSITIVITY" "$sensitivity"
		mv "$CONF_FILE" "$NEW_CONF_FILE"
		 		
		echo "#INF: Camera updated successfully"
	else
		echo "#ERR: Camera update failed"
	fi
fi


if [ "$1" != "" ] &amp;&amp; [ "$cam_code" = "" ]; then
	
	cd $ZONEDIR
	for z in *; do
		if test "$z" != "*"; then
			if test -z $ZONES; then
				ZONES="$z"
			else
				ZONES="$ZONES,$z"
			fi
		fi
	done

	# Loading contents from .info file
	. "$VIDEO_CONF_PATH/$1.conf"
	spaces_name=`echo "$NAME" | tr "+" " "`
	USR=`echo "$AUTH" | cut -d: -f1`
	PWD=`echo "$AUTH" | cut -d: -f2`

	echo "#&gt; Camera details"
	echo "form:`basename $0`
	cam_code	code	hidden	$1
	cam_name	Name	text	$spaces_name
	cam_zone	Zone	list[$ZONES]	$ZONE
	netcam_url	URL Streaming	text	$URL
	netcam_user	HTTP user authentication	text	$USR
	netcam_pass	HTTP password authentication	text	$PWD
	preview	Preview	image	$URL"
	
	if test -x /usr/bin/record; then
echo -n "
	night_vision	Covered camera detection	list[1:Yes,0:No]	$NIGHT_VISION
	sensitivity	Sensitivity	list[100:Very high,300:High,500:Normal,700:Low, 900:Very low]	$SENSITIVITY
"
fi
	echo "actions:"
	echo "	manageCameras.sh	Back to list"
    	echo 
else
   echo "#&gt; Camera list"
	echo "list:`basename $0`	selectable"
	for conf_file in `ls $VIDEO_CONF_PATH/*.conf 2&gt;/dev/null | grep -v common.conf`; do
		. "$conf_file"
		spaces_name=`echo "$NAME" | tr "+" " "`
		# Obtenemos el nombre y la url de streaming de la camara en cuestion
		cam_name=`basename "$conf_file" | cut -d"." -f1`	
	    echo -e "	-`basename $cam_name`	$spaces_name	camera"
	done
	echo "actions:"
	echo "	addIPCam.sh	Add"
	echo "	delIPCam.sh	Delete"

fi
echo
