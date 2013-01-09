#!/bin/sh

specs="specs"
#targspec=`dirname \`gcc --print-libgcc-file-name\``/specs
prefix=`mount | grep "/mingw type" | cut -d ' ' -f 1 | sed -e 's/\\\\/\\//'`

echo "*mingw_prefix:" > ${specs}
echo ${prefix} >> ${specs}
echo "" >> ${specs}

gcc -dumpspecs >> ${specs}

sed ':a;N;$!ba;s/*cc1plus:\n\n/*cc1plus:\n\-isystem\ \%(mingw_prefix)\/include\n/' ${specs} > specs_1
rm -f ${specs}
mv -f specs_1 ${specs}
