
# Docker conatainer stack: rtorrent (from sources), uTorrent + nginx + php-fpm 

Designed to work on raspbery pi using `resin/rpi-raspbian:jessie` as base image.

The image install nginx to listen on 80 and 443, default user: user, default password: password

## Run it

there is a run.sh

```
docker run -dt --name rpi-torrent_01 -p 8080:80 -p 8443:443 -p 49160:49160/udp -p 49161:49161 -v ~/data:/rtorrent rpi-torrent
```

## Build it

```
docker build -t rpi-torrent .
```

## Change login/password to the interface

When runing image you use the volume `/torrent`, modify `.htpasswd there` to change it. Example:

```
PASSWORD="my_password";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "my_user:{SSHA}$SHA1\n" >> /rtorrent/.htpasswd
```

## ToDo:

- Clean up
- Disable logs or redirect to stdout

