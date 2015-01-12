# Copyright 2014 Chernov A.A. <valexlin@gmail.com>
# This is a part of mingw-portage project: 
# http://sourceforge.net/projects/mingwportage/
# Distributed under the terms of the GNU General Public License v3

PATH="${PREFIX}/qt5/bin":"${PERL_PATH}/bin":${PATH}

qt5_module_src_configure()
{
	qmake -recursive
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
	# replace string
	local inst_root_w=`posix_w32path "${INSTDIR}/${PREFIX}"`

	local mkfiles=`find . -name 'Makefile.Release' -o -name "Makefile.*.Release"`
	local mkfile
	for mkfile in ${mkfiles}
	do
		echo "Patching ${mkfile}..."
		cat "${mkfile}" | sed -e "s|$r_pat|$inst_root_w|gi" > "${mkfile}.new"
		mv -f "${mkfile}.new" "${mkfile}"
	done

	make install
	if [ $? -eq 0 ]
	then
		eend "make install successfull."
	else
		eerror "make install failed!"
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