#!/bin/bash

if docker pull sdelrio/arm-curl-copy ; then
    echo - Getting arm curl from previous build
else

    mkdir build/curl-7.39.0
    make curl PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=resin/rpi-raspbian:jessie GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder
    docker build -t sdelrio/arm-curl-copy . -f -<<EOF
FROM busybox
COPY ./build/curl-7.39.0 /copy
EOF

    docker push sdelrio/arm-curl-copy
    echo - Pushing arm curl from next builds
fi

