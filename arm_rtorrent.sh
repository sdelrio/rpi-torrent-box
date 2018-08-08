#!/bin/bash

IMAGE=sdelrio/arm-rtorrent-copy

if docker pull $IMAGE ; then
    echo - Getting arm libtorrent from previous build
else

    mkdir rtorrent-$VER_RTORRENT
    make rtorrent PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=resin/rpi-raspbian:jessie GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder
    docker build -t $IMAGE . -f -<<EOF
FROM busybox
COPY ./build/rtorrent-$VER_RTORRENT /copy
EOF

    echo - Pushing arm libtorrent from next builds
    docker push $IMAGE
fi

