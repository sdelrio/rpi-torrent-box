#!/bin/bash
set -e

echo - Begin compile libtorrent-$VER_LIBTORRENT
cd libtorrent-$VER_LIBTORRENT

export CFLAGS="-w ${CFLAGS}"
export CXXFLAGS="${CFLAGS}"

echo - Autogent compile libtorrent-$VER_LIBTORRENT
./autogen.sh
echo - Configure compile libtorrent-$VER_LIBTORRENT

./configure --quiet --enable-silent-rules --with-posix-fallocate

#export CFLAGS="-O2 ${CFLAGS}"
#export CXXFLAGS="${CFLAGS}"
make V=0 --jobs $(nproc) -l$(nproc)

echo - Finish compile libtorrent-$VER_LIBTORRENT

