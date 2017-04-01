# Copyright 2014-2017 Chernov A.A. <valexlin@gmail.com>
# This is a part of mingw-portage project: 
# http://sourceforge.net/projects/mingwportage/
# Distributed under the terms of the GNU General Public License v2

PATH="${PREFIX}/qt5/bin":"${PERL_PATH}/bin":${PATH}

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

	if find "${INSTDIR}${PREFIX}/qt5/bin/"*.dll > /dev/null 2>&1
	then
		install -d "${INSTDIR}${PREFIX}/bin/"
		mv -f "${INSTDIR}${PREFIX}/qt5/bin/"*.dll \
				"${INSTDIR}${PREFIX}/bin/"
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
			sed -i "${f}" -e "s|set(imported_location\ \"\${\(.*_install_prefix\)}/qt5/bin/\${LIB_LOCATION}|set(imported_location\ \"\${\1}/bin/\${LIB_LOCATION}|"
			sed -i "${f}" -e "s|\"\${\(.*_install_prefix\)}/qt5/bin/\(.*\.dll\)\"|\"\${\1}/bin/\2\"|"
		done
	fi
}

# redefine defaults
src_configure()
{
	qt5_module_src_configure
}

src_install()
{
	qt5_modules_src_install
}
