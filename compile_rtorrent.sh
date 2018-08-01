#!/bin/bash
set -e

env
pwd

# PREPARE NEEDED LIBS

echo - Installing curl
cd curl-$CURL_VERSION && make install
cd ..
pwd

echo - Installing xmlrpc
cd xmlrpc-c && make install
cd ..
pwd

echo - Installing libtorrent
cd libtorrent-$VER_LIBTORRENT && make install
cd ..
pwd

# COMPILE RTORRENT

cd rtorrent-$VER_RTORRENT
./autogen.sh
./configure --with-xmlrpc-c --with-ncurses
make -j -l2
make install
ls -la /usr/local/lib
ls -la /usr/local/bin
ldconfig

