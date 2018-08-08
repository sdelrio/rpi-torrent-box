[![](https://img.shields.io/docker/stars/sdelrio/rpi-torrent-box.svg)](https://hub.docker.com/r/sdelrio/rpi-torrent-box 'DockerHub')

[![](https://img.shields.io/docker/pulls/sdelrio/rpi-torrent-box.svg)](https://hub.docker.com/r/sdelrio/rpi-torrent-box 'DockerHub')

[![Build Status](https://travis-ci.org/sdelrio/rpi-torrent-box.svg?branch=master)](https://travis-ci.org/sdelrio/rpi-torrent-box)

# Docker container stack: rtorrent (from sources), uTorrent + nginx + php-fpm 

Designed to work on **Raspbery Pi** and `x86_64`.

The image is already on docker hub. You can use it without building image:
- `sdelrio/rtorrent-box` for `x86_64`
- `sdelrio/rpi-torrent-box` for `arm` (Raspberry Pi).

The image install nginx to listen on 80 and 443, default user: user, default password: password


## Build it

There is a `Makefile` in the directory, you can use the gccbuilder from docker hub or make your own (`make gccbuilder`) .

```
make all
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

You can use environment vars `NEW_USER` and `NEW_PASS` to change password on container start. But if you want to manually edit the password file here is the instructions:

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

## Workarounds migrating to torrent 0.9.7 from older versions

Revise `.rtorrent.rc`, many values are deprecated and can’t be used, like:
- `load_start` -> `load.start`
- `use_udp_trackers` -> `trackers.use_udp.set`
- `peer_exchange` -> `protocol.pex.set`

Full list of parameters: <https://github.com/rakshasa/rtorrent/wiki/rTorrent-0.9-Comprehensive-Command-list-(WIP)>

## ToDo:

For now is just a release version to see how Docker Hub works with a build image.

- Disable logs or redirect to stdout
- Make changes on ports at rtorrent config using environment variables.

## Changelog

- Changed `x86_64` base image from `debian:jessie` to `debian:jessie-slim`.
- Refactored all compiled codes starting on v1.80,
  - Added different steps to generate files that will be included into the final image (`Dockerfile.pack`).
  - Separating in different steps could make in the future be executed in parallel in different nodes.
  - When changing some part not always needed to compile and make all.
  - Using this method reduced uncompressed image space for more than **150MB**.
```
sdelrio/rtorrent-box       v1.81               a739f1b2d297        23 hours ago        382MB
sdelrio/rtorrent-box       v1.20               290a9ff775b8        3 days ago          647MB
```
- Removed `Dockerfile` to differenciate and not make mistake wiht versions older than v1.80
- ruTorrent version update to master branch (>=3.8).
- rTorrent/rtorrentlib update to 0.9.7/0.13.7
- Updated variable names on `.rtorrent.rc`.
- Set fixed version to xmlrpc lib, since using `stable` and `super_stable` branches generated build problems.
- Removed apache2-tools to reduce image a little more.

