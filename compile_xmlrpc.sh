#!/bin/bash
set -e

cd xmlrpc-c
echo - Configure compiling xmlrpc

export CFLAGS="-w ${CFLAGS}"
export CXXFLAGS="${CFLAGS}"

./configure --quiet --enable-libxml2-backend --disable-abyss-server --disable-cgi-server
echo - Begin compiling xmlrpc
make V=0
echo - Finish compiling xmlrpc

