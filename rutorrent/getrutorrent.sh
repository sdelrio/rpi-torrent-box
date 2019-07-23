#!/bin/bash
set -e
# Get version from Novkc github
VERSION=v3.9

mkdir -p /usr/share/nginx/html
cd /usr/share/nginx/html
mkdir rutorrent
echo - Downloading rutorrent
curl -k -s -L https://github.com/Novik/ruTorrent/archive/${VERSION}.tar.gz | tar xz -C rutorrent --strip-components 1
rm -rf *.tar.gz
echo - Finished downloading rutorrent

