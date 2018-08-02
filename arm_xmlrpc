#!/bin/bash

if docker pull sdelrio/arm-xmlrpc-copy ; then
    echo - Getting arm xmlrpc from previous build
else

    mkdir build/xmlrpc-c
    make xmlrpc PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=resin/rpi-raspbian:jessie GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder
    docker build -t sdelrio/arm-xmlprc-copy . -f -<<EOF
FROM busybox
COPY ./build/xmlrpc /copy
EOF

    docker push sdelrio/arm-xmlrpc-copy
    echo - Pushing arm xmlrpc from next builds
fi

