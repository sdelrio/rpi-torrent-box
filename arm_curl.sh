#!/bin/bash

IMAGE=sdelrio/arm-curl-copy
CURL_VERSION = $(shell grep "ENV CURL_VERSION" Dockerfile.pack | awk 'NF>1{print $$NF}')
if docker pull $IMAGE ; then
    echo - Getting arm curl from previous build
else

    mkdir build/curl-$CURL_VERSION
    make curl PACK_IMAGENAME=sdelrio/rpi-torrent-box BUILDER_BASE=resin/rpi-raspbian:wheezy GCCBUILDER_IMAGENAME=sdelrio/rpi-gccbuilder
    docker build --build-arg CURL_VERSION=$CURL_VERSION -t $IMAGE . -f -<<EOF
FROM busybox
COPY ./build/curl-$CURL_VERSION /copy
EOF

    echo - Pushing arm curl from next builds
    docker push $IMAGE
fi

