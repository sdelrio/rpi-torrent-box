#!/bin/bash
set -e

echo - Begin compiling xmlrpc
cd xmlrpc-c
./configure --enable-libxml2-backend --disable-abyss-server --disable-cgi-server
make
echo - Finish compiling xmlrpc

