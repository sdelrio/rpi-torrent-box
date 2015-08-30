#!/bin/bash
docker run -dt --name rpi-torrent -p 7080:80 -p 7443:443 -p 7160:49160/udp -p 7161:49161 -v ~/data:/rtorrent rpi-torrent

