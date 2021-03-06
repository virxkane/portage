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


# edit makefile.mk
prefix_w=`posix_w32path "${PREFIX}"`
prefix_w=`echo ${prefix_w} | sed -e 's/\\//\\\/g'`
prefix_ws=`echo ${prefix_w} | sed -e 's/\\\/\\\\\\\/g'`

inst_drv=`echo ${prefix_w} | sed -e 's/^\(.*\:\).*/\1/'`
inst_top=`echo ${prefix_w} | sed -e "s/^${inst_drv}/\\$(INST_DRV)/"`
inst_top="${inst_top}\\perl"
inst_top=`echo ${inst_top} | sed -e 's/\\\/\\\\\\\/g'`
	
# set INST_DRV
cat makefile.mk | sed -e "s/^INST_DRV\\t\\*\\=.*$/INST_DRV\\t\\*\\=\\ ${inst_drv}/" > makefile.mk.new
mv -f makefile.mk.new makefile.mk
	
# set INST_TOP
cat makefile.mk | sed -e "s/^INST_TOP\\t\\*\\=.*$/INST_TOP\\t\\*\\=\\ ${inst_top}/" > makefile.mk.new
mv -f makefile.mk.new makefile.mk
	
# 
cat makefile.mk | sed -e 's/^#WIN64\t*\*\=\ undef$/WIN64\t\*\=\ undef/' > makefile.mk.new
mv -f makefile.mk.new makefile.mk
	
# set proper path to mingw
cat makefile.mk | sed -e "s/C\\:\\\\MinGW/${prefix_ws}/" > makefile.mk.new
mv -f makefile.mk.new makefile.mk

# uncomment GCC_4XX
cat makefile.mk | sed -e 's/^#GCC_4XX\t*\*\=\ define$/GCC_4XX\t\*\=\ define/' > makefile.mk.new
mv -f makefile.mk.new makefile.mk

# uncomment proper GCCHELPERDLL
cat makefile.mk | sed -e 's/^#GCCHELPERDLL\t*\*\=\ \$(CCHOME)\\bin\\libgcc_s_dw2-1\.dll$/GCCHELPERDLL\t\*\=\ \$(CCHOME)\\bin\\libgcc_s_dw2-1\.dll/' > makefile.mk.new
mv -f makefile.mk.new makefile.mk

# make build script for Windows Console
echo "set PATH=%SystemRoot%\system32;%SystemRoot%;${prefix_w}\bin" > build.cmd
echo "dmake %1 %2 %3 %4 %5 %6 %7 %8 %9" >> build.cmd
#echo "pause" >> build.cmd
echo "exit" >> build.cmd
