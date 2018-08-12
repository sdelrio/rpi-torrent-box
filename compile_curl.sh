#!/bin/bash
set -e
set -x

cd curl-$CURL_VERSION
echo - Configure compiling curl

export CFLAGS="-w ${CFLAGS}"
export CXXFLAGS="${CFLAGS}"

./configure --quiet --enable-silent-rules --enable-ares --enable-tls-srp --enable-gnu-tls --with-zlib --with-ssl
echo - Begin compiling curl
make V=0
make install
ls -la /usr/local/lib
ls -la /usr/local/bin

echo - Finish compiling curl

