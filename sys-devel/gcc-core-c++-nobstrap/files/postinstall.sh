#!/bin/sh

PREFIX="/mingw"
posix_w32path()
{
	local pwd1=`pwd`
	cd "$1"
	if [ $? -eq 0 ]
	then
		pwd -W
		cd ${pwd1}
	else
		echo ""
		die "Can't cd to $1"
	fi
}


echo "Fix specs file..."
targspecs=`dirname \`gcc --print-libgcc-file-name\``/specs
	
specs="${TMPDIR}/specs"
prefix_w=`posix_w32path "${PREFIX}"`

echo "*mingw_prefix:" > ${specs}
echo ${prefix_w} >> ${specs}
echo "" >> ${specs}

gcc -dumpspecs >> ${specs}

sed ':a;N;$!ba;s/*cc1plus:\n\n/*cc1plus:\n\-isystem\ \%(mingw_prefix)\/include\n/' ${specs} > ${targspecs}
