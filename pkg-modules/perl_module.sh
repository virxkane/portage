# Copyright 2014 Chernov A.A. <valexlin@gmail.com>
# This is a part of mingw-portage project: 
# http://sourceforge.net/projects/mingwportage/
# Distributed under the terms of the GNU General Public License v3

export PATH="${PERL_PATH}/bin:${PATH}"

perl_module_src_configure()
{
	perl Makefile.PL
	checkexitcode $? "configure failed"

	# make build script for Windows Console
	# local prefix_w=`posix_w32path "${PREFIX}"`
	# prefix_w=`echo ${prefix_w} | sed -e 's/\\//\\\/g'`
	# local perl_path_w=`posix_w32path "${PERL_PATH}"`
	# perl_path_w=`echo ${perl_path_w} | sed -e 's/\\//\\\/g'`
	# echo "set PATH=%SystemRoot%\system32;%SystemRoot%;${prefix_w}\bin;${perl_path_w}\bin" > build.cmd
	# echo "dmake %*" >> build.cmd
	# #echo "pause" >> build.cmd
	# echo "exit" >> build.cmd
}

perl_module_src_compile()
{
	# cmd //C build.cmd
	dmake
}

perl_module_src_install()
{
	local prefix_w=`posix_w32path "${PREFIX}"`
	local prefix_w=`echo ${prefix_w} | sed -e 's/\\//\\\/g'`
	local prefix_ws=`echo ${prefix_w} | sed -e 's/\\\/\\\\\\\/g'`

	mkdir -p "${INSTDIR}${PREFIX}"
	local tmp_prefix_w=`posix_w32path "${INSTDIR}${PREFIX}"`
	local tmp_prefix_w=`echo ${tmp_prefix_w} | sed -e 's/\\//\\\/g'`
	local tmp_prefix_ws=`echo ${tmp_prefix_w} | sed -e 's/\\\/\\\\\\\/g'`

	# patch Makefile to change native filenames to MSYS filenames...
	# fix SITELIBEXP
	cat Makefile | sed -e "s|^SITELIBEXP\s*\=.*$|SITELIBEXP\ \=\ ${PERL_PATH}/site/lib|" > Makefile.new
	mv -f Makefile.new Makefile

	# fix SITEARCHEXP
	cat Makefile | sed -e "s|^SITEARCHEXP\s*\=.*$|SITEARCHEXP\ \=\ ${PERL_PATH}/site/lib|" > Makefile.new
	mv -f Makefile.new Makefile

	# fix DIRFILESEP
	#cat Makefile | sed -e "s|^DIRFILESEP\s*\=.*$|DIRFILESEP\ \=\ /|" > Makefile.new
	#mv -f Makefile.new Makefile

	# fix PERLPREFIX
	cat Makefile | sed -e "s|^PERLPREFIX\s*\=.*$|PERLPREFIX\ \=\ ${PERL_PATH}|" > Makefile.new
	mv -f Makefile.new Makefile

	# fix SITEPREFIX
	cat Makefile | sed -e "s|^SITEPREFIX\s*\=.*$|SITEPREFIX\ \=\ ${PERL_PATH}/site|" > Makefile.new
	mv -f Makefile.new Makefile

	# fix INSTALLPRIVLIB
	cat Makefile | sed -e "s|^INSTALLPRIVLIB\s*\=.*$|INSTALLPRIVLIB\ \=\ ${PERL_PATH}/lib|" > Makefile.new
	mv -f Makefile.new Makefile

	# fix INSTALLSITELIB
	cat Makefile | sed -e "s|^INSTALLSITELIB\s*\=.*$|INSTALLSITELIB\ \=\ ${PERL_PATH}/site/lib|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLVENDORLIB
	cat Makefile | sed -e "s|^INSTALLVENDORLIB\s*\=.*$|INSTALLVENDORLIB\ \=\ ${PERL_PATH}/vendor/lib|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLARCHLIB
	cat Makefile | sed -e "s|^INSTALLARCHLIB\s*\=.*$|INSTALLARCHLIB\ \=\ ${PERL_PATH}/lib|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLSITEARCH
	cat Makefile | sed -e "s|^INSTALLSITEARCH\s*\=.*$|INSTALLSITEARCH\ \=\ ${PERL_PATH}/site/lib|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLVENDORARCH
	cat Makefile | sed -e "s|^INSTALLVENDORARCH\s*\=.*$|INSTALLVENDORARCH\ \=\ ${PERL_PATH}/vendor/lib|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLBIN
	cat Makefile | sed -e "s|^INSTALLBIN\s*\=.*$|INSTALLBIN\ \=\ ${PERL_PATH}/bin|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLSITEBIN
	cat Makefile | sed -e "s|^INSTALLSITEBIN\s*\=.*$|INSTALLSITEBIN\ \=\ ${PERL_PATH}/bin|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLVENDORBIN
	cat Makefile | sed -e "s|^INSTALLVENDORBIN\s*\=.*$|INSTALLVENDORBIN\ \=\ ${PERL_PATH}/bin|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLSCRIPT
	cat Makefile | sed -e "s|^INSTALLSCRIPT\s*\=.*$|INSTALLSCRIPT\ \=\ ${PERL_PATH}/bin|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# INSTALLSITESCRIPT already correct
	
	# fix INSTALLVENDORSCRIPT
	cat Makefile | sed -e "s|^INSTALLVENDORSCRIPT\s*\=.*$|INSTALLVENDORSCRIPT\ \=\ \$\(INSTALLSCRIPT\)|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLMAN1DIR
	cat Makefile | sed -e "s|^INSTALLMAN1DIR\s*\=.*$|INSTALLMAN1DIR\ \=\ ${PERL_PATH}/man/man1|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# INSTALLSITEMAN1DIR already correct
	
	# fix INSTALLVENDORMAN1DIR
	cat Makefile | sed -e "s|^INSTALLVENDORMAN1DIR\s*\=.*$|INSTALLVENDORMAN1DIR\ \=\ \$\(INSTALLMAN1DIR\)|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix INSTALLMAN3DIR
	cat Makefile | sed -e "s|^INSTALLMAN3DIR\s*\=.*$|INSTALLMAN3DIR\ \=\ ${PERL_PATH}/man/man3|" > Makefile.new
	mv -f Makefile.new Makefile
	
	# fix PERL_LIB
	#cat Makefile | sed -e "s|^PERL_LIB\s*\=.*$|PERL_LIB\ \=\ ${PERL_PATH}/lib|" > Makefile.new
	#mv -f Makefile.new Makefile
	
	# fix PERL_ARCHLIB
	#cat Makefile | sed -e "s|^PERL_ARCHLIB\s*\=.*$|PERL_ARCHLIB\ \=\ ${PERL_PATH}/lib|" > Makefile.new
	#mv -f Makefile.new Makefile
	
	# fix PERL_INC
	#cat Makefile | sed -e "s|^PERL_INC\s*\=.*$|PERL_INC\ \=\ ${PERL_PATH}/lib/CORE|" > Makefile.new
	#mv -f Makefile.new Makefile
	
	# INSTALLSITEMAN3DIR already correct
	
	# fix INSTALLVENDORMAN3DIR
	cat Makefile | sed -e "s|^INSTALLVENDORMAN3DIR\s*\=.*$|INSTALLVENDORMAN3DIR\ \=\ \$\(INSTALLMAN3DIR\)|" > Makefile.new
	mv -f Makefile.new Makefile

	install -d "${INSTDIR}"
	dmake DESTDIR="${INSTDIR}" install

	# lib/.packlist
	f="${INSTDIR}${PREFIX}/perl/site/lib/auto/XML/Parser/.packlist"
	cat "${f}" | sed -e "s/${tmp_prefix_ws}/${prefix_ws}/gi" > _file.tmp
	mv -f _file.tmp "${f}"
}

# redefine default functions
src_configure()
{
	perl_module_src_configure
}

src_compile()
{
	perl_module_src_compile
}

src_install()
{
	perl_module_src_install
}
