#!/bin/bash

# Create working directories if not exists
mkdir -p /rtorrent/{downloads,watch,.session,rutorrent/user-profiles,rutorrent/user-profiles/torrents}

# Change permission to ruTorrent's webserver user
chown -R www-data:www-data /rtorrent/{downloads,watch,.session,rutorrent/user-profiles,rutorrent/user-profiles/torrents}

# Make .htaccess configurable by the user using the volume maped on /rtorrent
if [ -f /rtorrent/.htpasswd ]; then
  cp -f /rtorrent/.htpasswd /usr/share/nginx/html/rutorrent/.htpasswd
else
  cp -f /usr/share/nginx/html/rutorrent/.htpasswd /rtorrent/.htpasswd 
fi

if [ -d /usr/share/nginx/html/rutorrent/conf/ ]; then
  cp -f /usr/local/src/config.php /usr/share/nginx/html/rutorrent/conf/config.php
fi

# ruTorrent web interface through nginx web server
nginx -g "daemon off;"
