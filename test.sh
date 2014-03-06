#!/bin/bash

# Try to compile all vcl files in /custom - Stop on error.
#
ORIG_PWD=`pwd`
cd custom
for config_vcl in *.vcl; do
	ERRORS_LINE=`(varnishd -n /tmp -C -pvcl_dir=$ORIG_PWD -f "${ORIG_PWD}/custom/${config_vcl}" 3>&1 1>&2 2>&3 3>&- 1>/dev/null) | wc -l`
	if [ $ERRORS_LINE -lt 3 ] ; then
		echo -e "\e[00;32m$config_vcl [ OK ]\e[00m";
	else 
		echo -e "\e[00;31m$config_vcl [ Error ] $ERRORS_LINE \e[00m";
		varnishd -n /tmp -C -pvcl_dir=$ORIG_PWD -f "${ORIG_PWD}/custom/${config_vcl}";
	fi;
done;
