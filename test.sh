#!/bin/bash
ORIG_PWD=`pwd`
cd defaults_vcl
for config_vcl in *.vcl; do
	varnishd -n /tmp -C -pvcl_dir=$ORIG_PWD -f "${ORIG_PWD}/defaults_vcl/${config_vcl}" >/dev/null 2>&1
	ERROR=$?
	if [ $ERROR -eq 0 ] ; then
		echo -e "\e[00;32m$config_vcl [ OK ]\e[00m";
	else 
		echo -e "\e[00;31m$config_vcl [ Error ] $ERROR\e[00m";
		varnishd -n /tmp -C -pvcl_dir=$ORIG_PWD -f $config_vcl;
	fi;	
done;
