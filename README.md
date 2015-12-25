
# Docker container stack: rtorrent (from sources), uTorrent + nginx + php-fpm 

Designed to work on **Raspbery Pi** using `resin/rpi-raspbian:jessie` as base image. You ca also modify to `debian:jessie` to make it run on `x86_64`.

The image install nginx to listen on 80 and 443, default user: user, default password: password

The image is already on docker hub. You can use it without building image.


## Build it

There is a `buid.sh` and `run.sh` in the directory, you can change your ports and volume for your needs, also de user/password for the web login:

```
docker build -t rpi-torrent-box .
```

## Run it

### Environment vars to change web user/pass

The environment `NEW_USER` and `NEW_PASS` are used for the web access login. If not defined, `user` and `password` are the defaults.

```
docker run -dt --name rpi-torrent_01 \
  -p 8080:80 -p 8443:443 -p 49160:49160/udp -p 49161:49161 
  -v ~/data:/rtorrent 
  -e NEW_USER=myuser
  -e NEW_PASS=mypass
  sdelrio/rpi-torrent-box
```

The URL to access interfaces is `http://<IP>:<PORT>`. No need to append `/rutorrent` on URL on this version.

### Environment vars to change rtorrent listening ports

The environment `RTORRENT_DHT` and `RTORRENT_PORT` changes the rtorrent configuration to listen on those ports instead the default 49160 and 49161. For example, lets change it to 50000 and 50001:

```
docker run -dt --name rpi-torrent_01 \
  -p 8080:80 -p 8443:443 -p 50000:50000/udp -p 50001:50001 
  -v ~/data:/rtorrent 
  -e RTORRENT_DHT=50000
  -e RTORRENT_PORT=50001
  sdelrio/rpi-torrent-box
```

## Modify manually login/password on .htpassword to access ruTorrent interface

When runing image you use the volume `/rtorrent`. Here you can set up or modify `.htpasswd` file.
You can add more users or just change using `>` instead `>>` in the redirection:

In the volume you used vefore with `-v ` (`~/data` in the example). You can execute:

```
PASSWORD="my_password";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "my_user:{SSHA}$SHA1\n" >> ~/data/.htpasswd
```

Or you can run a command inside the container, if your container is named `my-rpi-torrent`

```
$ docker exec -t my-rpi-torrent bash
# PASSWORD="my_password";SALT="$(openssl rand -base64 3)";SHA1=$(printf "$PASSWORD$SALT" | openssl dgst -binary -sha1 | sed 's#$#'"$SALT"'#' | base64);printf "my_user:{SSHA}$SHA1\n" >> /rtorrent/.htpasswd
```

After changing `.htpasswd` file you must stop/start container. The initial script will look for this file and copy where nginx load it.

## ToDo:

For now is just a release version to see how Docker Hub works with a buil image.

- Clean up
- Disable logs or redirect to stdout
- Reduce final image size
