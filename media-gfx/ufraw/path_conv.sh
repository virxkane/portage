#!/bin/sh

w32path_posix()
{
	local mingw_w32path=`mount | grep '/mingw ' | head -n 1 | cut -f 1 -d ' ' | sed -e 's/\\\/\\\\\//' | tr A-Z a-z`
	local usr_w32path=`mount | grep '/usr ' | head -n 1 | cut -f 1 -d ' ' | sed -e 's/\\\/\\\\\//' | tr A-Z a-z`
	local msys_w32path=`mount | grep '/msys ' | head -n 1 | cut -f 1 -d ' ' | sed -e 's/\\\/\\\\\//' | tr A-Z a-z`
	local tmp=`echo "$1" | sed -e "s/^${mingw_w32path}/\/mingw/"`
	if [ "${tmp}" = "$1" ]
	then
		tmp=`echo "$1" | sed -e "s/^${usr_w32path}/\/usr/"`
		if [ "${tmp}" = "$1" ]
		then
			tmp=`echo "$1" | sed -e "s/^${msys_w32path}/\/msys/"`
		fi
	fi
	echo "${tmp}"
}

path_w32="e:/mingw/lib/gimp/2.0"
path=`w32path_posix "${path_w32}"`
echo path=$path
