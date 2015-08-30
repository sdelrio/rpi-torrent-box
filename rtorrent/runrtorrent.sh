#!/bin/bash

# Check lock
if [ -f /rtorrent/.session/rtorrent.lock ]; then
    rm -f /rtorrent/.session/rtorrent.lock
fi

# Check config
if [ -f /rtorrent/.rtorrent.rc ]; then
    cp  /usr/local/src/.rtorrent.rc /rtorrent/.rtorrent.rc
fi

# Run rTorrent 
exec /usr/local/bin/rtorrent
