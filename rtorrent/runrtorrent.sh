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

if [ "$RTORRENT_PORT" ]; then
    sed -i "s/^port_range.*$/network.port_range.set/" /rtorrent/.rtorrent.rc
    sed -i "s/^network\.port_range\.set.*$/network.port_range.set=${RTORRENT_PORT}-${RTORRENT_PORT}/" /rtorrent/.rtorrent.rc
fi

# change listening port if env $RTORRENT_DHT is set

if [ "$RTORRENT_DHT" ]; then
    sed -i "s/^dht_port.*$/dht.port.set=/" /rtorrent/.rtorrent.rc
    sed -i "s/^dht\.port\.set.*$/dht.port.set=${RTORRENT_DHT}/" /rtorrent/.rtorrent.rc
fi

# clean lock file
if [ -f /session/rtorrent.lock ]; then
    rm -f /session/rtorrent.lock
fi

# Run rTorrent 
exec /usr/local/bin/rtorrent
