#!/bin/bash
set -e
set -x

cd curl-$CURL_VERSION
./configure --enable-ares --enable-tls-srp --enable-gnu-tls --with-zlib --with-ssl
make

ls -la /usr/local/lib
ls -la /usr/local/bin

