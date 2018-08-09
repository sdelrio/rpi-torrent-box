#!/bin/bash
set -e
set -x

pwd
ls

# PREPARE NEEDED LIBS

echo - Installing curl-$CURL_VERSION
ls curl-$CURL_VERSION
cd curl-$CURL_VERSION && make install V=0
cd ..
pwd

echo - Installing xmlrpc-c
ls xmlrpc-c
cd xmlrpc-c && make install V=0
cd ..
pwd

echo - Installing libtorrent-$VER_LIBTORRENT
ls libtorrent-$VER_LIBTORRENT
cd libtorrent-$VER_LIBTORRENT && make install V=0
cd ..
pwd

# COMPILE RTORRENT

cd rtorrent-$VER_RTORRENT
./autogen.sh
echo - Configure libtorrent-$VER_RTORRENT
./configure --quiet --enable-silent-rules --with-xmlrpc-c --with-ncurses
echo - Begin compile rtorrent
make -j -l2 V=0
echo - Finish compile rtorrent-$VER_RTORRENT
make install V=0
ls -la /usr/local/lib
ls -la /usr/local/bin
ldconfig

