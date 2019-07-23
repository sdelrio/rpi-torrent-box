#!/bin/bash
set -e

IMAGE=sdelrio/arm-libtorrent-copy
BUILDER_BASE=balenalib/raspberry-pi2-debian:jessie

if docker pull $IMAGE ; then
    echo - Getting arm libtorrent from previous build
else

    mkdir libtorrent-$VER_LIBTORRENT
    make libtorrent PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=$BUILDER_BASE GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder
    docker build --build-arg VER_LIBTORRENT=$VER_LIBTORRENT -t $IMAGE . -f -<<EOF
FROM busybox
COPY ./build/libtorrent-$VER_LIBTORRENT /copy
EOF

    echo - Pushing arm libtorrent from next builds
    docker push $IMAGE
fi

