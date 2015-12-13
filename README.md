
# Docker container stack: rtorrent (from sources), uTorrent + nginx + php-fpm 

Designed to work on **Raspbery Pi** using `resin/rpi-raspbian:jessie` as base image. You ca also modify to `debian:jessie` to make it run on `x86_64`.

The image install nginx to listen on 80 and 443, default user: user, default password: password

The image is already on docker hub. You can use it without building image.


## Run it

There is a `run.sh` in the directory, you can cchange your ports and volume for your needs:

```
docker run -dt --name rpi-torrent_01 -p 8080:80 -p 8443:443 -p 49160:49160/udp -p 49161:49161 -v ~/data:/rtorrent rpi-torrent-box
```

or if you want ot get docker hub image and not building it, use `sdelrio/rpi-torrent-box`:

```
docker run -dt --name rpi-torrent_01 -p 8080:80 -p 8443:443 -p 49160:49160/udp -p 49161:49161 -v ~/data:/rtorrent sdelrio/rpi-torrent-box
```

The URL to access interfaces is `http://<IP>:<PORT>/rutorrent`.

## Build it

```
docker build -t rpi-torrent-box .
```

## Modify login/password to access ruTorrent interface

When runing image you use the volume `/rtorrent`, to modify `.htpasswd` you can add more users or just change using `>` instead `>>` in the redirection:

```
docker exec -t rpi-torrent_01 PASSWORD="my_password";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "my_user:{SSHA}$SHA1\n" >> /rtorrent/.htpasswd
```

## ToDo:

For now is just a release version to see how Docker Hub works with a buil image.

- Clean up
- Disable logs or redirect to stdout
- Reduce final image size
