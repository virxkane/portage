# Copyright 2014-2017 Chernov A.A. <valexlin@gmail.com>
# This is a part of mingw-portage project: 
# http://sourceforge.net/projects/mingwportage/
# Distributed under the terms of the GNU General Public License v2

qt5_module_src_configure()
{
	qmake
	if [ $? -ne 0 ]
	then
		eerror "qmake failed!"
	fi
}

qt5_modules_src_install()
{
	mkdir -p "${INSTDIR}/${PREFIX}"

	local prefix_w=`posix_w32path "${PREFIX}"`
	local prefix_w_d=`echo $prefix_w | sed -e 's/^\(.\):.*/\1/'`
	      prefix_w_d=`echo $prefix_w_d`
	local prefix_w_p=`echo $prefix_w | sed -e 's/^.:\(.*\)/\1/'`
	# replace pattern
	local r_pat="${prefix_w_d}:\$(INSTALL_ROOT)${prefix_w_p}"
	local r_pat2="${prefix_w_d}:\$(INSTALL_ROOT:@msyshack@%=%)${prefix_w_p}"
	# replace string
	local inst_root_w=`posix_w32path "${INSTDIR}/${PREFIX}"`

	local mkfiles=`find . -name 'Makefile.Release' -o -name "Makefile.*.Release" -o -name 'Makefile'`
	local mkfile
	for mkfile in ${mkfiles}
	do
		echo "Patching ${mkfile}..."
		sed -e "s|$r_pat|$inst_root_w|gi" -i "${mkfile}"
		sed -e "s|$r_pat2|$inst_root_w|gi" -i "${mkfile}"
	done

	make install
	if [ $? -eq 0 ]
	then
		eend "make install successfull."
	else
		eerror "make install failed!"
	fi

	if [ -d "${INSTDIR}${PREFIX}/lib/qt5/cmake/" ]
	then
		#echo "Move cmake files..."
		mv "${INSTDIR}${PREFIX}/lib/qt5/cmake/" "${INSTDIR}${PREFIX}/lib/"
		local configFiles=`find "${INSTDIR}${PREFIX}/lib/" -name "*Config.cmake"`
		for f in ${configFiles}
		do
			echo "Fixing file ${f}"
			sed -i "${f}" -e "s|^get_filename_component(\(.*\)\ \"\${CMAKE_CURRENT_LIST_DIR}/\.\./\.\./\.\./\.\./\"\ ABSOLUTE)$|get_filename_component(\1 \"\${CMAKE_CURRENT_LIST_DIR}/\.\./\.\./\.\./\" ABSOLUTE)|"
		done
	fi

	if [ -d "${INSTDIR}${PREFIX}/lib/qt5/pkgconfig/" ]
	then
		#Move pkg-config files...
		mv "${INSTDIR}${PREFIX}/lib/qt5/pkgconfig/" "${INSTDIR}${PREFIX}/lib/" || die "mv pkg-config files failed!"
		local pkgconfigFiles=`find "${INSTDIR}${PREFIX}/lib/pkgconfig/" -name "*.pc"`
		for f in ${pkgconfigFiles}
		do
			echo "Fixing file ${f}"
			sed -i "${f}" -e "s|^prefix=.*$|prefix=${PREFIX}|"
		done
	fi
}

# redefine defaults
src_configure()
{
	qt5_module_src_configure
}

src_compile()
{
	# fix strange errors
	#   "qmlcachegen.exe: Bad address"
	# see https://github.com/msys2/MINGW-packages/issues/7528#issuecomment-751473282
	export MSYS2_ARG_CONV_EXCL='*'
	emake
}

src_install()
{
	qt5_modules_src_install
}
