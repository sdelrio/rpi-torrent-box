#!/bin/bash
set -e
set -x

IMAGE=sdelrio/arm-rtorrent-copy

if docker pull $IMAGE ; then
    echo - Getting arm rtorrent from previous build
else

    mkdir rtorrent-$VER_RTORRENT
    make rtorrent VER_RTORRENT=$VER_RTORRENT VER_LIBTORRENT=$VER_LIBTORRENT VER_CURL=$VER_CURL PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=resin/rpi-raspbian:wheezy GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder
    docker build -t $IMAGE . -f -<<EOF
FROM busybox
COPY ./build/rtorrent-$VER_RTORRENT /copy
EOF

    echo - Pushing arm libtorrent from next builds
    docker push $IMAGE
fi

