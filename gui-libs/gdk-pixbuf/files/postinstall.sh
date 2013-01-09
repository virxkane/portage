#!/bin/sh

PREFIX="/mingw"

echo "enum gdk-pixbuf-loader"
mkdir -p ${PREFIX}/etc/gtk-2.0
LANG=en ${PREFIX}/bin/gdk-pixbuf-query-loaders > "${PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
