#!/bin/sh

PREFIX="/mingw"

echo "enum gtk-immodules"
mkdir -p ${PREFIX}/etc/gtk-2.0
LANG=en ${PREFIX}/bin/gtk-query-immodules-2.0 > ${PREFIX}/etc/gtk-2.0/gtk.immodules
