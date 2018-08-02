#!/bin/bash

IMAGE=sdelrio/arm-curl-copy
if docker pull $IMAGE ; then
    echo - Getting arm curl from previous build
else

    mkdir build/curl-7.39.0
    make curl PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=resin/rpi-raspbian:jessie GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder
    docker build -t $IMAGE . -f -<<EOF
FROM busybox
COPY ./build/curl-7.39.0 /copy
EOF

    echo - Pushing arm curl from next builds
    docker push $IMAGE
fi

