#!/bin/bash
set -e

echo - Begin compile libtorrent-$VER_LIBTORRENT
cd libtorrent-$VER_LIBTORRENT
echo - Autogent compile libtorrent-$VER_LIBTORRENT
./autogen.sh
echo - Configure compile libtorrent-$VER_LIBTORRENT
./configure --quiet --enable-glibc-back-compat --enable-silent-rules --with-posix-fallocate
make V=0
echo - Finish compile libtorrent-$VER_LIBTORRENT

