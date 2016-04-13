#!/bin/bash
set -e
set -x

APPLICATION=$1
VERSION=$2


if [ -f ./Dockerfile ]; then
 docker_dir=./
else
 echo "Dockerfile not found."
 exit 1
fi

if [ -z $VERSION ]; then
  VERSION=latest
fi

if [ -z $APPLICATION ]; then
  APPLICATION=rpi-rtorrent-box
fi 

docker build -t $APPLICATION:$VERSION $docker_dir
