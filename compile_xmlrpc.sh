#!/bin/bash
set -e

cd xmlrpc-c
echo - Configure compiling xmlrpc
./configure --quiet --enable-libxml2-backend --disable-abyss-server --disable-cgi-server
echo - Begin compiling xmlrpc
make V=0 > /dev/null
echo - Finish compiling xmlrpc

