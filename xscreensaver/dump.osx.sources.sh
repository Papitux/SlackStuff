#!/bin/sh
# Repacks the xscreensaver tarball to remove the unneeded OSX sources.

VERSION=${VERSION:-$(echo xscreensaver-*.tar.?z* | rev | cut -f 3- -d . | cut -f 1 -d - | rev)}

tar xf xscreensaver-${VERSION}.tar.xz || exit 1
mv xscreensaver-${VERSION}.tar.xz xscreensaver-${VERSION}.tar.xz.orig
rm -r xscreensaver-${VERSION}/OSX/*
tar cf xscreensaver-${VERSION}.tar xscreensaver-${VERSION}
rm -r xscreensaver-${VERSION}
xz -9 xscreensaver-${VERSION}.tar
touch -r xscreensaver-${VERSION}.tar.xz.orig xscreensaver-${VERSION}.tar.xz
rm xscreensaver-${VERSION}.tar.xz.orig
