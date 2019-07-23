#!/bin/bash

IMAGE=sdelrio/arm-xmlrpc-copy
BUILDER_BASE=balenalib/raspberry-pi2-debian:jessie

if docker pull $IMAGE ; then
    echo - Getting arm xmlrpc from previous build
else

    mkdir build/xmlrpc-c
    make xmlrpc PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=$BUILDER_BASE GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder
    docker build -t $IMAGE . -f -<<EOF
FROM busybox
COPY ./build/xmlrpc-c /copy
EOF

    echo - Pushing arm xmlrpc from next builds
    docker push $IMAGE
fi

