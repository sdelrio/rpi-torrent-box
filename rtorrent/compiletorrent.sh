#!/bin/bash

#build_deps="automake build-essential ca-certificates libc-ares-dev libcppunit-dev libtool"; \
#build_deps="${build_deps} libssl-dev libxml2-dev libncurses5-dev pkg-config subversion wget"; \
set -x && \
apt-get update && apt-get install -q -y --no-install-recommends ${build_deps} && \
wget http://curl.haxx.se/download/curl-7.39.0.tar.gz && \
tar xzvfp curl-7.39.0.tar.gz && \
cd curl-7.39.0 && \
./configure --enable-ares --enable-tls-srp --enable-gnu-tls --with-zlib --with-ssl && \
make -j -l2 && \
make install && \
cd .. && \
rm -rf curl-* && \
ldconfig && \
svn --non-interactive --trust-server-cert checkout https://svn.code.sf.net/p/xmlrpc-c/code/stable/ xmlrpc-c && \
cd xmlrpc-c && \
./configure --enable-libxml2-backend --disable-abyss-server --disable-cgi-server && \
make -j -l2 && \
make install && \
cd .. && \
rm -rf xmlrpc-c && \
ldconfig && \
wget -O libtorrent-$VER_LIBTORRENT.tar.gz https://github.com/rakshasa/libtorrent/archive/$VER_LIBTORRENT.tar.gz && \
tar xzf libtorrent-$VER_LIBTORRENT.tar.gz && \
cd libtorrent-$VER_LIBTORRENT && \
./autogen.sh && \
./configure --with-posix-fallocate && \
make -j -l2 && \
make install && \
cd .. && \
rm -rf libtorrent-* && \
ldconfig && \
wget -O rtorrent-$VER_RTORRENT.tar.gz https://github.com/rakshasa/rtorrent/archive/$VER_RTORRENT.tar.gz && \
tar xzf rtorrent-$VER_RTORRENT.tar.gz && \
cd rtorrent-$VER_RTORRENT && \
./autogen.sh && \
./configure --with-xmlrpc-c --with-ncurses && \
make -j -l2 && \
make install && \
cd .. && \
rm -rf rtorrent-* && \
ldconfig 
