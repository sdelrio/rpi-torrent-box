#!/bin/bash
set -e

echo - Begin compile libtorrent-$VER_LIBTORRENT
cd libtorrent-$VER_LIBTORRENT
./autogen.sh
./configure --with-posix-fallocate
make
echo - Finish compile libtorrent-$VER_LIBTORRENT

