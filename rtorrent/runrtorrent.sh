#!/bin/bash

# Check lock
if [ -f /rtorrent/.session/rtorrent.lock ]; then
    rm -f /rtorrent/.session/rtorrent.lock
fi

# Check config
if [ ! -f /rtorrent/.rtorrent.rc ]; then
    cp /usr/local/src/.rtorrent.rc /rtorrent/.rtorrent.rc
fi

# change listening port if env $RTORRENT_PORT is set

if [ -f $RTORRENT_PORT ]; then
    sed -i 's/^port_range/port_range=${RTORRENT_PORT}-${RTORRENT_PORT}' /rtorrent/.rtorrent.rc
fi

# change listening port if env $RTORRENT_DHT is set

if [ -f $RTORRENT_DHT ]; then
    sed -i 's/^dht_port/dht_port=${RTORRENT_DHT}' /rtorrent/.rtorrent.rc
fi

# Run rTorrent 
exec /usr/local/bin/rtorrent
