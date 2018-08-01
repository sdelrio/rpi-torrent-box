#!/bin/bash
set -e

cd xmlrpc-c
echo - Configure compiling xmlrpc
./configure --quiet --enable-silent-rules --enable-libxml2-backend --disable-abyss-server --disable-cgi-server
echo - Begin compiling xmlrpc
make V=0
echo - Finish compiling xmlrpc

