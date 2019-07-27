#!/bin/bash
set -e
# Get version from Novkc github
VERSION=v3.10-beta
mkdir -p /usr/share/nginx/html
cd /usr/share/nginx/html
mkdir rutorrent
echo - Downloading rutorrent
curl -k -s -L https://github.com/Novik/ruTorrent/archive/${VERSION}.tar.gz | tar xz -C rutorrent --strip-components 1
rm -rf *.tar.gz
rm -rf rutorrent/plugins/_cloudflare
echo - Finished downloading rutorrent
#cd /tmp
#mkdir cfscrape
#curl -k -s -L curl https://github.com/Anorov/cloudflare-scrape/archive/2.0.7.tar.gz | tar xz -C cfscrape
#cd /tmp
#python setup.py install
