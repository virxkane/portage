#!/bin/sh

PREFIX="/mingw"

echo "enum pango modules"
mkdir -pv ${PREFIX}/etc/pango
${PREFIX}/bin/pango-querymodules > ${PREFIX}/etc/pango/pango.modules
