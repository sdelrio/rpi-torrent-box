#!/bin/bash
docker run -dt --name rpi-torrent -p 8080:80 -p 7443:443 -p 49160:49160/udp -p 49161:49161 -v ~/data:/rtorrent sdelrio/rtorrent-box
