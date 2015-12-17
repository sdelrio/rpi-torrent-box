#!/bin/bash

# Create working directories if not exists
mkdir -p /rtorrent/{downloads,watch,.session,rutorrent/user-profiles,rutorrent/user-profiles/torrents}

# Change permission to ruTorrent's webserver user
chown -R www-data:www-data /rtorrent/{downloads,watch,.session,rutorrent/user-profiles,rutorrent/user-profiles/torrents}

PASS_FILE=/rtorrent/.htpasswd

if [ "$NEW_USER" ] && [ "$NEW_PASS" ]; then
  PASSWORD="$NEW_PASS";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "$NEW_USER:{SSHA}$SHA1\n" > $PASS_FILE
fi

# Make .htaccess configurable by the user using the volume maped on /rtorrent
if [ -f $PASS_FILE ]; then
  cp -f $PASS_FILE /usr/share/nginx/html/rutorrent/.htpasswd
else
  cp -f /usr/share/nginx/html/rutorrent/.htpasswd $PASS_FILE
fi

if [ -d /usr/share/nginx/html/rutorrent/conf/ ]; then
  cp -f /usr/local/src/config.php /usr/share/nginx/html/rutorrent/conf/config.php
fi

# ruTorrent web interface through nginx web server
nginx -g "daemon off;"
