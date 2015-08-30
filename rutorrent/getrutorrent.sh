#!/bin/bash

# Get master version from Novkc github

mkdir -p /usr/share/nginx/html && \
cd /usr/share/nginx/html && \
mkdir rutorrent && \
curl -k -L -O https://github.com/Novik/ruTorrent/archive/master.tar.gz && \
tar xzvf master.tar.gz -C rutorrent --strip-components 1 && \
rm -rf *.tar.gz
